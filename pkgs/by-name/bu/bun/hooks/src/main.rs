use std::{
    collections::{BTreeMap, HashMap},
    env, fs,
    io::{BufRead, BufReader, Read, Write},
    net::{TcpListener, TcpStream},
    path::{Path, PathBuf},
    process,
    sync::atomic::{AtomicUsize, Ordering},
    thread, time::Duration,
};

use anyhow::{Context, Result, bail};
use data_encoding::{BASE64, HEXLOWER};
use isahc::{
    HttpClient, ReadResponseExt,
    config::{CaCertificate, Configurable, SslOption},
};
use rayon::prelude::*;
use serde::Deserialize;
use serde_json::{Value, json};
use sha1::{Digest, Sha1};
use sha2::Sha512;

const REGISTRY: &str = "https://registry.npmjs.org";
const REGISTRY_HOST_PLACEHOLDER: &str = "REGISTRY-HOST-PLACEHOLDER";

fn main() -> Result<()> {
    if let Ok(jobs) = env::var("NIX_BUILD_CORES")
        && !jobs.is_empty()
    {
        rayon::ThreadPoolBuilder::new()
            .num_threads(
                jobs.parse()
                    .expect("NIX_BUILD_CORES must be a whole number"),
            )
            .build_global()
            .unwrap();
    }

    let args: Vec<String> = env::args().skip(1).collect();
    match args.first().map(String::as_str) {
        Some("--help") | Some("-h") | None => usage(),
        // An optional `fetch` subcommand is allowed so that plain
        // `prefetch-bun-deps <src> <out>` keeps working.
        Some("fetch") => fetch(&args[1..]),
        Some(_) => fetch(&args),
    }
}

fn usage() -> ! {
    println!("usage: prefetch-bun-deps [--filter=<workspace>]... <src> <out>");
    println!();
    println!(
        "Prefetches bun dependencies as an offline npm registry mirror for usage by bun.fetchDeps."
    );
    process::exit(1);
}

fn fetch(args: &[String]) -> Result<()> {
    let mut positional: Vec<PathBuf> = Vec::new();

    for arg in args {
        match arg.as_str() {
            "--help" | "-h" => usage(),
            _ if arg.starts_with("--filter=") => {
                // Workspaces only matter for the install done by bunConfigHook;
                // the lockfile contains the whole workspace tree regardless.
            }
            _ if arg.starts_with('-') => bail!("unknown option: {arg}"),
            _ => positional.push(arg.into()),
        }
    }

    let [src, out]: [PathBuf; 2] = positional.try_into().map_err(|_| {
        anyhow::anyhow!("exactly a source directory and an output directory are required")
    })?;

    let lockfile_path = src.join("bun.lock");
    if !lockfile_path.is_file() {
        bail!(
            "no bun.lock found in {}\n\n\
             prefetch-bun-deps only supports text lockfiles. A binary bun.lockb \
             cannot be used; make sure the project uses `bun.lock` (the default \
             since bun 1.2).",
            src.display()
        );
    }

    println!("Parsing lockfile {}", lockfile_path.display());
    let lockfile = fs::read_to_string(&lockfile_path)?;
    let (registry_deps, tarball_deps) = parse_lockfile(&lockfile)?;
    println!(
        "Found {} registry packages and {} tarball packages",
        registry_deps.len(),
        tarball_deps.len()
    );

    fs::create_dir_all(&out)?;
    let out = out.canonicalize()?;

    let client = make_http_client()?;

    // Group by package name so that every packument is only downloaded once.
    let mut by_name: BTreeMap<&str, Vec<(&str, &str)>> = BTreeMap::new();
    for dep in &registry_deps {
        by_name
            .entry(dep.name.as_str())
            .or_default()
            .push((dep.version.as_str(), dep.integrity.as_str()));
    }

    let progress = AtomicUsize::new(0);
    let total = by_name.len();

    by_name
        .par_iter()
        .try_for_each(|(name, versions)| -> Result<(), anyhow::Error> {
        let packument = fetch_packument(&client, name)?;
        let package_dir = out.join(name);
        fs::create_dir_all(package_dir.join("-"))?;

        let mut dists = Vec::with_capacity(versions.len());
        for (version, integrity) in versions {
            let dist = packument
                .pointer(&format!("/versions/{version}/dist"))
                .with_context(|| format!("packument for {name} has no version {version}"))?;
            let tarball_url = dist
                .get("tarball")
                .and_then(Value::as_str)
                .with_context(|| format!("packument for {name}@{version} has no tarball"))?;

            let tarball = get_bytes(&client, tarball_url)
                .with_context(|| format!("failed to download tarball {tarball_url}"))?;
            verify_sri(&tarball, integrity)
                .with_context(|| format!("integrity mismatch for {name}@{version}"))?;

            let tarball_name = tarball_name(tarball_url);
            fs::write(package_dir.join("-").join(tarball_name), &tarball)?;
            dists.push((*version, *integrity, tarball_name));
        }

        let manifest = synthesize_manifest(name, &dists);
        fs::write(package_dir.join("manifest.json"), manifest.to_string())?;

        let done = progress.fetch_add(1, Ordering::SeqCst) + 1;
        if done % 100 == 0 || done == total {
            eprintln!("Fetched {done}/{total} packages");
        }
        Ok(())
    })?;

    // Group tarball dependencies by package name and fetch them in parallel.
    let mut tarball_by_name: BTreeMap<&str, Vec<&TarballDep>> = BTreeMap::new();
    for dep in &tarball_deps {
        tarball_by_name.entry(dep.name.as_str()).or_default().push(dep);
    }

    tarball_by_name
        .par_iter()
        .try_for_each(|(name, deps)| -> Result<(), anyhow::Error> {
            let package_dir = out.join(name);
            fs::create_dir_all(package_dir.join("-"))?;

            let mut versions = BTreeMap::new();
            for dep in deps {
                let tarball = get_bytes(&client, &dep.url)
                    .with_context(|| format!("failed to download {}", dep.url))?;
                verify_sri(&tarball, &dep.integrity)
                    .with_context(|| format!("integrity mismatch for {}", dep.spec))?;

                fs::write(package_dir.join("-").join(&dep.tarball_name), &tarball)?;
                versions.insert(
                    dep.version.clone(),
                    json!({
                        "dist": {
                            "tarball": placeholder_url(name, &dep.tarball_name),
                            "integrity": dep.integrity,
                        },
                    }),
                );
            }

            let manifest = json!({
                "name": name,
                "versions": versions,
            });
            fs::write(package_dir.join("manifest.json"), manifest.to_string())?;
            Ok(())
        })?;

    let packages = fs::read_dir(&out)?.count();
    println!("Prefetched {packages} packages into {}", out.display());

    Ok(())
}

#[derive(Deserialize)]
struct BunLock {
    #[serde(default)]
    packages: HashMap<String, Vec<Value>>,
}

struct RegistryDep {
    name: String,
    version: String,
    integrity: String,
}

/// A dependency whose tarball URL is known upfront, e.g. pinned github
/// dependencies or `https://` tarball URLs.
struct TarballDep {
    spec: String,
    name: String,
    version: String,
    url: String,
    tarball_name: String,
    integrity: String,
}

/// Splits a lockfile spec into its package name and resolution, correctly
/// handling scoped names (`@scope/name@version`).
fn split_spec(spec: &str) -> Option<(&str, &str)> {
    let search_start = if let Some(rest) = spec.strip_prefix('@') {
        rest.find('/')? + 1
    } else {
        0
    };
    let split = spec[search_start..].find('@')? + search_start;
    Some((&spec[..split], &spec[split + 1..]))
}

fn parse_lockfile(content: &str) -> Result<(Vec<RegistryDep>, Vec<TarballDep>)> {
    let lock: BunLock = json5::from_str(content).context("failed to parse bun.lock")?;

    let mut registry_deps = Vec::new();
    let mut tarball_deps = Vec::new();

    for (key, entry) in lock.packages {
        let Some(spec) = entry.first().and_then(Value::as_str) else {
            bail!("lockfile entry {key:?} has no resolution spec");
        };
        let Some((name, resolution)) = split_spec(spec) else {
            bail!("lockfile entry {key:?} has an unrecognised spec {spec:?}");
        };
        let integrity = || {
            entry
                .iter()
                .filter_map(Value::as_str)
                .find(|s| {
                    s.starts_with("sha512-") || s.starts_with("sha384-") || s.starts_with("sha1-")
                })
                .with_context(|| format!("lockfile entry {spec:?} has no integrity hash"))
                .map(str::to_owned)
        };

        if resolution.starts_with("workspace:")
            || resolution.starts_with("link:")
            // `file:` dependencies are stored without their prefix and
            // resolved by bun from the project source during install.
            || resolution.starts_with("file:")
            || (!resolution.contains("://") && resolution.contains('/'))
        {
            continue;
        } else if let Some(rest) = resolution.strip_prefix("github:") {
            let Some((repo_path, rev)) = rest.rsplit_once('#') else {
                bail!("github dependency {spec:?} is not pinned to a revision");
            };
            let Some((owner, repo)) = repo_path.split_once('/') else {
                bail!("github dependency {spec:?} has an invalid repository");
            };
            // bun records the name it uses for the github tarball in the
            // lockfile entry.
            let tarball_name = entry
                .iter()
                .filter_map(Value::as_str)
                .find(|s| !s.starts_with("sha") && *s != spec)
                .with_context(|| format!("lockfile entry {spec:?} has no tarball name"))?
                .to_owned();
            tarball_deps.push(TarballDep {
                spec: spec.to_owned(),
                name: name.to_owned(),
                version: resolution.to_owned(),
                url: format!("https://codeload.github.com/{owner}/{repo}/tar.gz/{rev}"),
                tarball_name,
                integrity: integrity()?,
            });
        } else if resolution.starts_with("https://") || resolution.starts_with("http://") {
            // The resolution itself is a tarball URL.
            tarball_deps.push(TarballDep {
                spec: spec.to_owned(),
                name: name.to_owned(),
                version: resolution.to_owned(),
                url: resolution.to_owned(),
                tarball_name: tarball_name(resolution).replace('/', "%2F"),
                integrity: integrity()?,
            });
        } else if resolution.starts_with("npm:")
            || resolution.starts_with("git:")
            || resolution.starts_with("git+")
        {
            bail!(
                "unsupported dependency {spec:?}\n\n\
                 prefetch-bun-deps only supports npm registry, pinned github and \
                 tarball URL dependencies."
            );
        } else {
            registry_deps.push(RegistryDep {
                name: name.to_owned(),
                version: resolution.to_owned(),
                integrity: integrity()?,
            });
        }
    }

    Ok((registry_deps, tarball_deps))
}

fn make_http_client() -> Result<HttpClient> {
    let mut builder = HttpClient::builder();

    // Respect SSL_CERT_FILE if the environment variable exists. When the file
    // does not exist, assume we are downloading in a FOD and therefore do not
    // need to check certificates, since the output is already hashed. (The
    // same logic prefetch-npm-deps uses.)
    if let Ok(ssl_cert_file) = env::var("SSL_CERT_FILE") {
        if Path::new(&ssl_cert_file).exists() {
            builder = builder.ssl_ca_certificate(CaCertificate::file(ssl_cert_file));
        } else if env::var("outputHash").is_ok() {
            builder = builder.ssl_options(SslOption::DANGER_ACCEPT_INVALID_CERTS);
        }
    }


    Ok(builder.build()?)
}

fn get_bytes(client: &HttpClient, url: &str) -> Result<Vec<u8>> {
    let mut last_error = None;
    for attempt in 0..5 {
        if attempt > 0 {
            std::thread::sleep(Duration::from_secs(2u64 << (attempt - 1).min(3)));
        }
        match client.get(url) {
            Ok(mut response) => {
                let status = response.status();
                if status.is_success() {
                    return Ok(response.bytes()?);
                }
                bail!("request to {url} failed with status {status}");
            }
            Err(error) => {
                last_error = Some(anyhow::Error::from(error));
            }
        }
    }
    Err(last_error.unwrap_or_else(|| anyhow::anyhow!("request failed")))
        .with_context(|| format!("request to {url} failed"))
}

fn fetch_packument(client: &HttpClient, name: &str) -> Result<Value> {
    let mut last_error = None;
    for attempt in 0..5 {
        if attempt > 0 {
            std::thread::sleep(Duration::from_secs(2u64 << (attempt - 1).min(3)));
        }
        let request = isahc::Request::get(format!("{REGISTRY}/{}", registry_path(name)))
            .header("Accept", "application/vnd.npm.install-v1+json")
            .body(())
            .with_context(|| format!("failed to build packument request for {name}"))?;
        match client.send(request) {
            Ok(mut response) => {
                let status = response.status();
                if status.is_success() {
                    let body = response.bytes()?;
                    return serde_json::from_slice(&body)
                        .with_context(|| format!("failed to parse packument for {name}"));
                }
                bail!("packument request for {name} failed with status {status}");
            }
            Err(error) => {
                last_error = Some(anyhow::Error::from(error));
            }
        }
    }
    Err(last_error.unwrap_or_else(|| anyhow::anyhow!("packument request failed")))
        .with_context(|| format!("packument request for {name} failed"))
}

/// Scoped package names are served from nested directories, `@scope/name`
/// becomes `<out>/@scope/name`. In URLs the inner slash is percent-encoded,
/// matching the npm registry.
fn registry_path(name: &str) -> String {
    match name.strip_prefix('@') {
        Some(rest) => format!("@{}", rest.replace('/', "%2F")),
        None => name.to_owned(),
    }
}

fn tarball_name(url: &str) -> &str {
    url.rsplit('/').next().unwrap_or(url)
}

fn placeholder_url(name: &str, tarball_name: &str) -> String {
    format!(
        "http://{REGISTRY_HOST_PLACEHOLDER}/{}/-/{tarball_name}",
        registry_path(name)
    )
}

fn synthesize_manifest(name: &str, dists: &[(&str, &str, &str)]) -> Value {
    let mut versions = BTreeMap::new();
    for (version, integrity, tarball_name) in dists {
        versions.insert(
            version.to_string(),
            json!({
                "dist": {
                    "tarball": placeholder_url(name, tarball_name),
                    "integrity": integrity,
                },
            }),
        );
    }
    json!({
        "name": name,
        "versions": versions,
    })
}

fn verify_sri(data: &[u8], sri: &str) -> Result<()> {
    let Some((algo, expected)) = sri.split_once('-') else {
        bail!("invalid SRI: {sri:?}");
    };
    let expected = BASE64
        .decode(expected.as_bytes())
        .with_context(|| format!("invalid SRI base64 in {sri:?}"))?;
    let computed = match algo {
        "sha512" => Sha512::digest(data).to_vec(),
        "sha1" => Sha1::digest(data).to_vec(),
        _ => bail!("unsupported SRI algorithm {algo:?}"),
    };
    if computed != expected {
        bail!(
            "expected {}, got {}",
            HEXLOWER.encode(&expected),
            HEXLOWER.encode(&computed)
        );
    }
    Ok(())
}

fn handle_connection(stream: TcpStream, root: &Path, port: u16) -> Result<()> {
    let mut reader = BufReader::new(stream.try_clone()?);
    let mut stream = stream;

    loop {
        let mut request_line = String::new();
        if reader.read_line(&mut request_line)? == 0 {
            return Ok(());
        }

        let mut parts = request_line.split_whitespace();
        let method = parts.next().unwrap_or_default().to_owned();
        let target = parts.next().unwrap_or_default().to_owned();
        if method.is_empty() || target.is_empty() {
            return Ok(());
        }

        let mut content_length = 0usize;
        loop {
            let mut line = String::new();
            if reader.read_line(&mut line)? == 0 {
                return Ok(());
            }
            let line = line.trim_end();
            if line.is_empty() {
                break;
            }
            if let Some(value) = line
                .strip_prefix("Content-Length:")
                .or_else(|| line.strip_prefix("content-length:"))
            {
                content_length = value.trim().parse().unwrap_or(0);
            }
        }

        // Drain any request body.
        if content_length > 0 {
            let mut body = vec![0; content_length];
            reader.read_exact(&mut body)?;
        }

        let path = target.split('?').next().unwrap_or_default();
        let head_only = method == "HEAD";

        let (status, content_type, body) = match route(root, path, port) {
            Ok((content_type, body)) => ("200 OK", content_type, body),
            Err(RouteError::NotFound) => (
                "404 Not Found",
                "text/plain".to_owned(),
                b"not found".to_vec(),
            ),
            Err(RouteError::Other(error)) => {
                eprintln!("serve: {error:#}");
                (
                    "500 Internal Server Error",
                    "text/plain".to_owned(),
                    b"error".to_vec(),
                )
            }
        };

        write!(
            stream,
            "HTTP/1.1 {status}\r\nContent-Type: {content_type}\r\nContent-Length: {}\r\nConnection: keep-alive\r\n\r\n",
            body.len()
        )?;
        if !head_only {
            stream.write_all(&body)?;
        }
        stream.flush()?;
    }
}

enum RouteError {
    NotFound,
    Other(anyhow::Error),
}

impl From<anyhow::Error> for RouteError {
    fn from(error: anyhow::Error) -> Self {
        RouteError::Other(error)
    }
}

fn route(
    root: &Path,
    raw_path: &str,
    port: u16,
) -> std::result::Result<(String, Vec<u8>), RouteError> {
    let path = percent_decode(raw_path);
    if path.split('/').any(|segment| segment == "..") {
        return Err(RouteError::NotFound);
    }

    let relative = path.trim_start_matches('/');
    if relative.is_empty() {
        return Err(RouteError::NotFound);
    }

    let fs_path = root.join(relative);
    if fs_path.is_dir() {
        let manifest = fs::read(fs_path.join("manifest.json")).map_err(|_| RouteError::NotFound)?;
        let manifest = String::from_utf8(manifest)
            .map_err(anyhow::Error::from)?
            .replace(REGISTRY_HOST_PLACEHOLDER, &format!("127.0.0.1:{port}"))
            .into_bytes();
        Ok(("application/json".to_owned(), manifest))
    } else if fs_path.is_file() {
        let body = fs::read(&fs_path).map_err(|error| RouteError::Other(error.into()))?;
        Ok(("application/octet-stream".to_owned(), body))
    } else {
        Err(RouteError::NotFound)
    }
}

fn percent_decode(input: &str) -> String {
    let bytes = input.as_bytes();
    let mut output = Vec::with_capacity(bytes.len());
    let mut i = 0;
    while i < bytes.len() {
        if bytes[i] == b'%' && i + 3 <= bytes.len() {
            if let Ok(byte) =
                u8::from_str_radix(std::str::from_utf8(&bytes[i + 1..i + 3]).unwrap_or_default(), 16)
            {
                output.push(byte);
                i += 3;
                continue;
            }
        }
        output.push(bytes[i]);
        i += 1;
    }
    String::from_utf8_lossy(&output).into_owned()
}
