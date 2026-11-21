use anyhow::{Context, bail};
use backoff::{ExponentialBackoff, retry};
use data_encoding::BASE64;
use digest::Digest;
use isahc::{
    Body, Request, RequestExt,
    config::{CaCertificate, Configurable, RedirectPolicy, SslOption},
};
use log::info;
use nix_nar::{Encoder, NarError};
use serde_json::{Map, Value};
use sha2::Sha256;
use std::{
    env,
    io::{self, Read},
    path::Path,
};
use url::Url;

/// Rewrite a registry URL to use an `NIX_NPM_REGISTRY_OVERRIDES` mirror.
fn apply_registry_mirror(url: &Url, mirror: &str) -> anyhow::Result<Url> {
    let mut mirrored =
        Url::parse(mirror).with_context(|| format!("invalid registry mirror `{mirror}`"))?;
    if mirrored.host_str().is_none() {
        bail!("registry mirror `{mirror}` has no host");
    }

    // Bare-host mirrors have path `/`; trim trailing slashes before joining.
    let mut path = mirrored.path().trim_end_matches('/').to_owned();
    path.push_str(url.path());
    mirrored.set_path(&path);
    mirrored.set_query(url.query());
    mirrored.set_fragment(url.fragment());

    Ok(mirrored)
}

pub fn get_url(url: &Url) -> Result<Body, anyhow::Error> {
    let url_ = url.clone();
    let mut url = url.clone();
    // NIX_NPM_REGISTRY_OVERRIDES maps registry hosts to mirror URL prefixes, e.g.
    // `{"registry.npmjs.org": "https://mirror.example.com/npm"}`.
    if let Some(host) = url.host_str()
        && let Ok(npm_mirrors) = env::var("NIX_NPM_REGISTRY_OVERRIDES")
        && let Ok(mirrors) = serde_json::from_str::<Map<String, Value>>(&npm_mirrors)
        && let Some(mirror) = mirrors.get(host).and_then(serde_json::Value::as_str)
    {
        url = apply_registry_mirror(&url, mirror)?;
        eprintln!("Replaced URL {url_} with {url}");
    }

    let mut request = Request::get(url.as_str()).redirect_policy(RedirectPolicy::Limit(10));

    // Respect SSL_CERT_FILE if environment variable exists
    if let Ok(ssl_cert_file) = env::var("SSL_CERT_FILE") {
        if Path::new(&ssl_cert_file).exists() {
            // When file exists, use it. NIX_SSL_CERT_FILE will still override.
            request = request.ssl_ca_certificate(CaCertificate::file(ssl_cert_file));
        } else if env::var("outputHash").is_ok() {
            // When file does not exist, assume we are downloading in a FOD and
            // therefore do not need to check certificates, since the output is
            // already hashed.
            request = request.ssl_options(SslOption::DANGER_ACCEPT_INVALID_CERTS);
        }
    }

    // Respect NIX_NPM_TOKENS environment variable, which should be a JSON mapping in the shape of:
    // `{ "registry.example.com": "example-registry-bearer-token", ... }`
    if let Some(host) = url.host_str()
        && let Ok(npm_tokens) = env::var("NIX_NPM_TOKENS")
        && let Ok(tokens) = serde_json::from_str::<Map<String, Value>>(&npm_tokens)
        && let Some(token) = tokens.get(host).and_then(serde_json::Value::as_str)
    {
        info!("Found npm token for {host}. Adding authorization header to request.");
        request = request.header("Authorization", format!("Bearer {token}"));
    }

    let res = request.body(())?.send()?;
    if !res.status().is_success() {
        if res.status().is_client_error() {
            bail!("Client error: {}", res.status());
        }
        if res.status().is_server_error() {
            bail!("Server error: {}", res.status());
        }
        bail!("{}", res.status());
    }
    Ok(res.into_body())
}

pub fn get_url_body_with_retry(url: &Url) -> Result<Vec<u8>, anyhow::Error> {
    retry(ExponentialBackoff::default(), || {
        get_url(url)
            .and_then(|mut body| {
                let mut buf = Vec::new();

                body.read_to_end(&mut buf)?;

                Ok(buf)
            })
            .map_err(|err| match err.downcast_ref::<isahc::Error>() {
                Some(isahc_err) => {
                    if isahc_err.is_network() || isahc_err.is_timeout() {
                        backoff::Error::transient(err)
                    } else {
                        backoff::Error::permanent(err)
                    }
                }
                None => backoff::Error::permanent(err),
            })
    })
    .map_err(|backoff_err| match backoff_err {
        backoff::Error::Permanent(err)
        | backoff::Error::Transient {
            err,
            retry_after: _,
        } => err,
    })
}

pub fn make_sri_hash(path: &Path) -> Result<String, NarError> {
    let mut encoder = Encoder::new(path)?;
    let mut hasher = Sha256::new();

    io::copy(&mut encoder, &mut hasher)?;

    Ok(format!("sha256-{}", BASE64.encode(&hasher.finalize())))
}

#[cfg(test)]
mod tests {
    use super::apply_registry_mirror;
    use url::Url;

    fn rewrite(url: &str, mirror: &str) -> String {
        apply_registry_mirror(&Url::parse(url).unwrap(), mirror)
            .unwrap()
            .to_string()
    }

    const TARBALL: &str = "https://registry.npmjs.org/esbuild/-/esbuild-0.28.2.tgz";

    #[test]
    fn bare_host_mirror_keeps_one_slash() {
        assert_eq!(
            rewrite(TARBALL, "https://registry.npmmirror.com"),
            "https://registry.npmmirror.com/esbuild/-/esbuild-0.28.2.tgz"
        );
    }

    #[test]
    fn mirror_path_prefix_is_joined_with_one_slash() {
        assert_eq!(
            rewrite(TARBALL, "https://mirror.example/npm//"),
            "https://mirror.example/npm/esbuild/-/esbuild-0.28.2.tgz"
        );
    }

    #[test]
    fn mirror_scheme_host_and_port_are_used() {
        assert_eq!(
            rewrite(TARBALL, "http://[::1]:4873"),
            "http://[::1]:4873/esbuild/-/esbuild-0.28.2.tgz"
        );
    }

    #[test]
    fn request_path_query_and_fragment_are_preserved() {
        assert_eq!(
            rewrite(
                "https://registry.npmjs.org/@scope%2fpkg/-/pkg-1.0.0.tgz?write=true#integrity",
                "https://registry.npmmirror.com/"
            ),
            "https://registry.npmmirror.com/@scope%2fpkg/-/pkg-1.0.0.tgz?write=true#integrity"
        );
    }

    #[test]
    fn invalid_mirrors_are_rejected() {
        let url = Url::parse(TARBALL).unwrap();
        for mirror in ["not a url", "file:///tmp/npm"] {
            assert!(
                apply_registry_mirror(&url, mirror).is_err(),
                "mirror should have been rejected: {mirror}"
            );
        }
    }
}
