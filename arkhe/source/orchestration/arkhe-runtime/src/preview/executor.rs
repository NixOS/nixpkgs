//! A fixed Podman test executor. Qualification is an independently signed input,
//! never inferred from successful code execution or a self-reported probe.
use super::{PreviewSpec, PreviewTrust};
use arkhe_core::{canonical::encode_value, Digest32};
use serde::{Deserialize, Serialize};
use std::{
    collections::BTreeMap,
    path::{Path, PathBuf},
    time::Duration,
};
use tokio::{io::AsyncReadExt, process::Command};

pub const VECTORS: [&str; 22] = [
    "identity",
    "cgroup-enforcement",
    "mount-inventory",
    "socket-local-control",
    "tcp-egress",
    "udp-egress",
    "dns-egress",
    "image-read-control",
    "writable-control",
    "input-read-control",
    "input-write",
    "image-write",
    "outside-mount-canary",
    "traversal-and-symlink",
    "subprocess-control",
    "ffi-control",
    "mount-capability",
    "seccomp-inventory",
    "tmp-noexec",
    "memory-bounded",
    "cpu-bounded",
    "pids-bounded",
];
#[derive(Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ExecutorConfig {
    #[serde(default)]
    pub authority: Option<super::authority::AuthorityPolicy>,
    pub podman: PathBuf,
    pub connection: String,
    pub artifact_store: PathBuf,
    pub qualification: PathBuf,
    pub qualification_key: [u8; 32],
    pub trust_file: PathBuf,
}
#[derive(Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Qualification {
    pub version: u16,
    pub image: String,
    pub runtime_profile: Digest32,
    pub engine_identity: Digest32,
    pub executor_digest: Digest32,
    pub issued_at: i64,
    pub expires_at: i64,
    pub evidence_digest: Digest32,
    pub vectors: BTreeMap<String, String>,
    pub signature: String,
}
impl Qualification {
    pub fn signing_bytes(&self) -> Vec<u8> {
        let mut v = serde_json::to_value(self).expect("qualification");
        v.as_object_mut().unwrap().remove("signature");
        let mut bytes = b"AKG:PREVIEW:QUALIFICATION:v1\0".to_vec();
        bytes.extend(encode_value(&v));
        bytes
    }
    pub fn verify(
        &self,
        spec: &PreviewSpec,
        key: &[u8; 32],
        engine: Digest32,
        binary: Digest32,
        now: i64,
    ) -> Result<(), String> {
        if self.version != 1
            || self.image != spec.image
            || self.runtime_profile != spec.runtime_profile
            || self.runtime_profile != profile_digest()
            || self.engine_identity != engine
            || self.executor_digest != binary
            || self.evidence_digest == Digest32::ZERO
            || self.issued_at < 0
            || self.issued_at > now
            || self.expires_at <= now
            || self.expires_at.saturating_sub(self.issued_at) > 86400
            || self.vectors.len() != 22
            || VECTORS
                .iter()
                .any(|v| self.vectors.get(*v).map(String::as_str) != Some("PASS"))
        {
            return Err("executor qualification missing, stale or bound to another runtime".into());
        }
        super::verify_signature(key, &self.signing_bytes(), &self.signature)
    }
}
pub fn profile_digest() -> Digest32 {
    Digest32::blake3(
        b"AKG:PREVIEW:EXECUTOR:v1\0",
        &encode_value(&serde_json::json!({
            "command":"cargo test --locked --offline -p MODULE", "network":"none","read_only":1,
            "uid":"10001:10001","cap_drop":"ALL","no_new_privileges":1,"memory":1610612736u64,
            "memory_swap":1610612736u64,"pids":128,"cpus":2,"work_tmpfs":1073741824u64,
            "tmp_tmpfs":67108864,"tmp_noexec":1,"deadline_seconds":120,"max_output_bytes":1048576
        })),
    )
}
#[derive(Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct SourceBundle {
    pub baseline: BTreeMap<String, String>,
    pub proposal: BTreeMap<String, String>,
}
fn content_digest(bytes: &[u8]) -> String {
    Digest32::blake3(b"", bytes).to_hex()
}
impl SourceBundle {
    pub fn baseline_digest(&self) -> Digest32 {
        Digest32::blake3(
            b"AKG:PREVIEW:BASELINE:v1\0",
            &encode_value(&serde_json::to_value(&self.baseline).unwrap()),
        )
    }
    pub fn proposal_digest(&self) -> Digest32 {
        Digest32::blake3(
            b"AKG:PREVIEW:PROPOSAL:v1\0",
            &encode_value(&serde_json::to_value(&self.proposal).unwrap()),
        )
    }
    pub fn manifest(&self) -> BTreeMap<String, String> {
        let mut m = self.baseline.clone();
        for (p, v) in &self.proposal {
            m.insert(p.clone(), content_digest(v.as_bytes()));
        }
        m
    }
    pub fn artifact_digest(&self) -> Digest32 {
        Digest32::blake3(
            b"AKG:PREVIEW:ARTIFACT:v1\0",
            &encode_value(&serde_json::to_value(self.manifest()).unwrap()),
        )
    }
    pub fn verify(&self, spec: &PreviewSpec) -> Result<(), String> {
        if self.baseline.is_empty()
            || self.baseline.len() > 5000
            || self.proposal.is_empty()
            || self.proposal.len() > 8
            || self.proposal.values().map(|v| v.len()).sum::<usize>() > 65536
            || self.baseline_digest() != spec.baseline_digest
            || self.proposal_digest() != spec.proposal_digest
            || self.artifact_digest() != spec.artifact_digest
        {
            return Err("source bundle binding mismatch".into());
        }
        for p in self.baseline.keys().chain(self.proposal.keys()) {
            safe_path(p)?;
        }
        if !spec
            .module
            .bytes()
            .all(|b| b.is_ascii_alphanumeric() || b == b'-' || b == b'_')
            || spec.module.is_empty()
        {
            return Err("invalid Rust module".into());
        }
        // Only Rust source/tests within the selected crate may be changed.
        for p in self.proposal.keys() {
            let parts: Vec<_> = p.split('/').collect();
            if parts.len() < 4
                || parts[1] != spec.module
                || !matches!(parts[2], "src" | "tests")
                || !p.ends_with(".rs")
            {
                return Err("proposal escapes selected Rust crate".into());
            }
        }
        Ok(())
    }
}
fn safe_path(p: &str) -> Result<(), String> {
    if p.is_empty()
        || p.contains('\\')
        || p.contains(':')
        || p.split('/').any(|c| c.is_empty() || c == "." || c == "..")
        || !p
            .bytes()
            .all(|b| b.is_ascii_alphanumeric() || b"-_/.".contains(&b))
    {
        return Err("invalid source path".into());
    }
    Ok(())
}
pub fn read_json<T: serde::de::DeserializeOwned>(path: &Path) -> Result<T, String> {
    use std::io::Read;
    let mut f = std::fs::File::open(path).map_err(|_| "configured preview file unavailable")?;
    if !f
        .metadata()
        .map_err(|_| "file metadata unavailable")?
        .is_file()
    {
        return Err("regular file required".into());
    }
    let mut bytes = vec![];
    std::io::Read::by_ref(&mut f)
        .take(262145)
        .read_to_end(&mut bytes)
        .map_err(|_| "preview file read failed")?;
    if bytes.len() > 262144 {
        return Err("preview file exceeds 256 KiB".into());
    }
    serde_json::from_slice(&bytes).map_err(|_| "invalid preview JSON".into())
}

pub struct PreparedExecution {
    config: ExecutorConfig,
    spec: PreviewSpec,
    stage: PathBuf,
    engine: Digest32,
    binary: Digest32,
    cleanup_allowed: std::sync::atomic::AtomicBool,
}
impl Drop for PreparedExecution {
    fn drop(&mut self) {
        if !self
            .cleanup_allowed
            .load(std::sync::atomic::Ordering::SeqCst)
        {
            return;
        }
        // Verify the resolved target immediately before recursive cleanup on Windows.
        if let (Ok(stage), Ok(temp)) = (
            self.stage.canonicalize(),
            std::env::temp_dir().canonicalize(),
        ) {
            if stage.parent() == Some(temp.as_path())
                && stage
                    .file_name()
                    .is_some_and(|v| v.to_string_lossy().starts_with("arkhe-preview-sealed-"))
            {
                let _ = std::fs::remove_dir_all(stage);
            }
        }
    }
}
// stage is created by this process under temp with a UUID. No caller path is removed.
pub async fn prepare(
    config: ExecutorConfig,
    spec: &PreviewSpec,
    now: i64,
) -> Result<PreparedExecution, String> {
    if config.connection.is_empty() || !config.podman.is_absolute() {
        return Err("absolute Podman path and named connection required".into());
    }
    let q: Qualification = read_json(&config.qualification)?;
    // Reject missing/forged qualification before even invoking the engine.
    q.verify(
        spec,
        &config.qualification_key,
        q.engine_identity,
        q.executor_digest,
        now,
    )?;
    let authority = config
        .authority
        .as_ref()
        .ok_or("external qualification authority not admitted")?;
    super::authority::admit(authority, config.qualification_key, spec, now).await?;
    let engine = engine_identity(&config).await?;
    let binary = Digest32::blake3(
        b"",
        &std::fs::read(std::env::current_exe().map_err(|_| "executor path unavailable")?)
            .map_err(|_| "executor bytes unavailable")?,
    );
    q.verify(spec, &config.qualification_key, engine, binary, now)?;
    let dir = config.artifact_store.join(spec.artifact_digest.to_hex());
    let bundle: SourceBundle = read_json(&dir.join("bundle.json"))?;
    bundle.verify(spec)?;
    let stage = std::env::temp_dir().join(format!("arkhe-preview-sealed-{}", uuid::Uuid::new_v4()));
    std::fs::create_dir(&stage).map_err(|_| "staging unavailable")?;
    let prepared = PreparedExecution {
        config,
        spec: spec.clone(),
        stage,
        engine,
        binary,
        cleanup_allowed: std::sync::atomic::AtomicBool::new(true),
    };
    let source = dir.join("source");
    let manifest = bundle.manifest();
    let mut total = 0u64;
    let mut found = BTreeMap::new();
    copy_source(&source, &source, &prepared.stage, &mut found, &mut total)?;
    if found != manifest {
        return Err("artifact content or file set mismatch".into());
    }
    Ok(prepared)
}
fn copy_source(
    root: &Path,
    current: &Path,
    dest: &Path,
    manifest: &mut BTreeMap<String, String>,
    total: &mut u64,
) -> Result<(), String> {
    let meta = std::fs::symlink_metadata(current).map_err(|_| "source missing")?;
    if meta.is_symlink() {
        return Err("source symlink rejected".into());
    }
    if meta.is_dir() {
        for e in std::fs::read_dir(current).map_err(|_| "source inventory failed")? {
            copy_source(
                root,
                &e.map_err(|_| "source entry unavailable")?.path(),
                dest,
                manifest,
                total,
            )?;
        }
    } else if meta.is_file() {
        let relative = current
            .strip_prefix(root)
            .map_err(|_| "invalid source root")?
            .to_str()
            .ok_or("source path not UTF8")?
            .replace('\\', "/");
        safe_path(&relative)?;
        *total = total.saturating_add(meta.len());
        if *total > 50 * 1024 * 1024 || manifest.len() >= 5000 {
            return Err("source limit exceeded".into());
        }
        let bytes = std::fs::read(current).map_err(|_| "source read failed")?;
        let target = dest.join(&relative);
        std::fs::create_dir_all(target.parent().unwrap())
            .map_err(|_| "staging directory failed")?;
        std::fs::write(target, &bytes).map_err(|_| "staging write failed")?;
        manifest.insert(relative, content_digest(&bytes));
    } else {
        return Err("non-regular source rejected".into());
    }
    Ok(())
}
pub async fn engine_identity(c: &ExecutorConfig) -> Result<Digest32, String> {
    let (_, bytes) = command(c, &["info", "--format", "json"], 20, 262144).await?;
    let info: serde_json::Value =
        serde_json::from_slice(&bytes).map_err(|_| "Podman info invalid")?;
    let host = &info["host"];
    if host["security"]["rootless"] != true {
        return Err("rootless engine required".into());
    }
    // uptime is excluded; boot_id obtained inside the engine's own host namespace.
    #[cfg(not(windows))]
    let (_, boot) = command(
        c,
        &[
            "machine",
            "ssh",
            &c.connection,
            "cat",
            "/proc/sys/kernel/random/boot_id",
        ],
        20,
        1024,
    )
    .await?;
    #[cfg(windows)]
    let boot = {
        // Podman/WSL distributions use the observed "podman-<machine>" name.
        // Query the fixed kernel file directly; no SSH key permissions are changed.
        let exe = PathBuf::from(
            std::env::var_os("SystemRoot").ok_or("Windows system directory unavailable")?,
        )
        .join("System32/wsl.exe");
        let distro = format!("podman-{}", c.connection);
        let mut cmd = Command::new(exe);
        cmd.args([
            "--distribution",
            &distro,
            "--exec",
            "cat",
            "/proc/sys/kernel/random/boot_id",
        ])
        .env_clear();
        for k in ["PATH", "USERPROFILE", "SYSTEMROOT", "TEMP", "TMP"] {
            if let Some(v) = std::env::var_os(k) {
                cmd.env(k, v);
            }
        }
        cmd.creation_flags(0x08000000);
        let output = tokio::time::timeout(
            Duration::from_secs(10),
            cmd.stdin(std::process::Stdio::null())
                .kill_on_drop(true)
                .output(),
        )
        .await
        .map_err(|_| "engine boot observation timed out")?
        .map_err(|_| "engine boot observation unavailable")?;
        if !output.status.success() || output.stdout.len() > 128 {
            return Err("engine boot observation rejected".into());
        }
        output.stdout
    };
    let boot = String::from_utf8(boot).map_err(|_| "boot identity invalid")?;
    if boot.trim().len() != 36 {
        return Err("engine boot identity unavailable".into());
    }
    Ok(Digest32::blake3(
        b"AKG:PREVIEW:ENGINE:v1\0",
        &encode_value(
            &serde_json::json!({"connection":c.connection,"boot_id":boot.trim(),"hostname":host["hostname"],"kernel":host["kernel"],"arch":host["arch"],"version":info["version"],"oci_runtime":serde_json::to_string(&host["ociRuntime"]).map_err(|_|"OCI runtime identity invalid")?}),
        ),
    ))
}
pub async fn revalidate(
    prepared: &PreparedExecution,
    trust: &PreviewTrust,
    now: i64,
) -> Result<(), String> {
    let q: Qualification = read_json(&prepared.config.qualification)?;
    if trust.emergency_stop
        || prepared.config.qualification_key == trust.supervisor_key
        || prepared.config.qualification_key == trust.reviewer_key
        || trust.image != prepared.spec.image
        || trust.runtime_profile != profile_digest()
    {
        return Err("executor policy revoked".into());
    }
    let authority = prepared
        .config
        .authority
        .as_ref()
        .ok_or("external qualification authority missing")?;
    if authority.root_key == trust.supervisor_key || authority.root_key == trust.reviewer_key {
        return Err("external root overlaps preview signers".into());
    }
    super::authority::admit(
        authority,
        prepared.config.qualification_key,
        &prepared.spec,
        now,
    )
    .await?;
    if engine_identity(&prepared.config).await? != prepared.engine {
        return Err("runtime changed after qualification".into());
    }
    q.verify(
        &prepared.spec,
        &prepared.config.qualification_key,
        prepared.engine,
        prepared.binary,
        now,
    )
}

/// All errors after dispatch are conservatively ambiguous unless cleanup is observed.
pub async fn execute(
    p: &PreparedExecution,
    cancel: std::sync::Arc<std::sync::atomic::AtomicBool>,
) -> Result<serde_json::Value, String> {
    use std::sync::atomic::Ordering;
    p.cleanup_allowed.store(false, Ordering::SeqCst);
    let name = format!("arkhe-preview-{}", uuid::Uuid::new_v4());
    let volume = format!(
        "{}:/input:ro",
        p.stage.to_str().ok_or("staging path invalid")?
    );
    let args = [
        "create",
        "--name",
        &name,
        "--pull=never",
        "--network=none",
        "--read-only",
        "--cap-drop=ALL",
        "--security-opt=no-new-privileges",
        "--user=10001:10001",
        "--pids-limit=128",
        "--memory=1536m",
        "--memory-swap=1536m",
        "--cpus=2",
        "--tmpfs=/work:rw,exec,size=1073741824,mode=1777",
        "--tmpfs=/tmp:rw,noexec,size=67108864",
        "--volume",
        &volume,
        "--workdir=/input",
        "--env=CARGO_HOME=/opt/cargo",
        "--env=CARGO_TARGET_DIR=/work/target",
        "--env=CARGO_NET_OFFLINE=true",
        "--entrypoint=cargo",
        &p.spec.image,
        "test",
        "--locked",
        "--offline",
        "-p",
        &p.spec.module,
    ];
    let (_, id) = command(&p.config, &args, 20, 4096)
        .await
        .map_err(|_| format!("container creation uncertain; reconcile owned name {name}"))?;
    let id = String::from_utf8(id)
        .map_err(|_| "container identity invalid")?
        .trim()
        .to_string();
    if id.len() != 64 || !id.bytes().all(|b| b.is_ascii_hexdigit()) {
        return Err("container identity missing; reconciliation required".into());
    }
    let result=async{
        if cancel.load(Ordering::SeqCst){return Err("execution cancelled".into());}
        let (_,inspect)=command(&p.config,&["inspect",&id],15,262144).await?;
        let records:serde_json::Value=serde_json::from_slice(&inspect).map_err(|_|"container inspect invalid")?;
        let c=&records[0];
        verify_container_policy(c,&p.spec)?;
        let expected=p.stage.to_str().ok_or("staging path invalid")?.replace('\\',"/");
        let mapped=if expected.as_bytes().get(1)==Some(&b':') {format!("/mnt/{}/{}",expected[..1].to_ascii_lowercase(),&expected[3..])}else{expected.clone()};
        let input=c["Mounts"].as_array().and_then(|a|a.iter().find(|m|m["Destination"]=="/input")).and_then(|m|m["Source"].as_str()).ok_or("input mount source unavailable")?.replace('\\',"/");
        if input!=expected && input!=mapped{return Err("input mount does not bind sealed source".into());}
        if cancel.load(Ordering::SeqCst){return Err("execution cancelled before start".into());}
        let start_args=["start","--attach",&id];
        let execution=command(&p.config,&start_args,120,1048576);
        tokio::pin!(execution);
        let output=loop{tokio::select!{r=&mut execution=>break r?,_=tokio::time::sleep(Duration::from_millis(200))=>{if cancel.load(Ordering::SeqCst){return Err("lease lost; execution cancelled".into());}}}};
        let (_,state)=command(&p.config,&["inspect","--format","{{json .State}}",&id],15,65536).await?;
        let state:serde_json::Value=serde_json::from_slice(&state).map_err(|_|"container final state invalid")?;
        if state["Running"]!=false||state["ExitCode"]!=0||!output.0{return Err("preview tests failed".into());}
        Ok(serde_json::json!({"container_id":id,"image":p.spec.image,"runtime_profile":profile_digest(),"engine_identity":p.engine,"artifact_digest":p.spec.artifact_digest,"output_digest":content_digest(&output.1),"exit_code":0,"scope":"isolated Rust tests; no deploy"}))
    }.await;
    command(&p.config, &["rm", "--force", &id], 15, 65536)
        .await
        .map_err(|_| "container cleanup uncertain")?;
    let (code, _) = raw_command(&p.config, &["container", "exists", &id], 10, 4096).await?;
    if code != 1 {
        return Err("container absence not established".into());
    }
    p.cleanup_allowed.store(true, Ordering::SeqCst);
    result
}
pub fn verify_container_policy(c: &serde_json::Value, spec: &PreviewSpec) -> Result<(), String> {
    let h = &c["HostConfig"];
    let config = &c["Config"];
    let empty = |v: &serde_json::Value| v.as_array().is_some_and(|a| a.is_empty());
    let security = h["SecurityOpt"]
        .as_array()
        .is_some_and(|a| a.iter().any(|s| s == "no-new-privileges"));
    let drops = h["CapDrop"]
        .as_array()
        .ok_or("capability inventory unavailable")?;
    let caps = [
        "CAP_CHOWN",
        "CAP_DAC_OVERRIDE",
        "CAP_FOWNER",
        "CAP_FSETID",
        "CAP_KILL",
        "CAP_NET_BIND_SERVICE",
        "CAP_SETFCAP",
        "CAP_SETGID",
        "CAP_SETPCAP",
        "CAP_SETUID",
        "CAP_SYS_CHROOT",
    ];
    let mounts = c["Mounts"]
        .as_array()
        .ok_or("mount inventory unavailable")?;
    let binds: Vec<_> = mounts.iter().filter(|m| m["Type"] == "bind").collect();
    if c["Image"] != spec.image
        || config["User"] != "10001:10001"
        || h["NetworkMode"] != "none"
        || h["ReadonlyRootfs"] != true
        || h["Privileged"] != false
        || !empty(&h["CapAdd"])
        || !security
        || caps.iter().any(|cap| !drops.iter().any(|v| v == cap))
        || h["Memory"] != 1610612736i64
        || h["MemorySwap"] != 1610612736i64
        || h["PidsLimit"] != 128
        || h["CpuQuota"] != 200000
        || h["CpuPeriod"] != 100000
        || config["Entrypoint"] != serde_json::json!(["cargo"])
        || config["Cmd"] != serde_json::json!(["test", "--locked", "--offline", "-p", spec.module])
        || config["WorkingDir"] != "/input"
        || binds.len() != 1
        || binds[0]["Destination"] != "/input"
        || binds[0]["RW"] != false
        || mounts
            .iter()
            .any(|m| !matches!(m["Destination"].as_str(), Some("/input" | "/tmp" | "/work")))
        || !h["Tmpfs"]["/tmp"]
            .as_str()
            .is_some_and(|s| s.split(',').any(|v| v == "noexec") && s.contains("size=67108864"))
        || !h["Tmpfs"]["/work"]
            .as_str()
            .is_some_and(|s| s.contains("size=1073741824"))
    {
        return Err("effective container policy differs from qualified profile".into());
    }
    Ok(())
}
pub async fn command(
    c: &ExecutorConfig,
    args: &[&str],
    seconds: u64,
    limit: u64,
) -> Result<(bool, Vec<u8>), String> {
    let (code, bytes) = raw_command(c, args, seconds, limit).await?;
    if code != 0 {
        return Err("Podman command failed".into());
    }
    Ok((true, bytes))
}
async fn raw_command(
    c: &ExecutorConfig,
    args: &[&str],
    seconds: u64,
    limit: u64,
) -> Result<(i32, Vec<u8>), String> {
    let mut cmd = Command::new(&c.podman);
    cmd.args(["--connection", &c.connection])
        .args(args)
        .env_clear();
    for k in ["PATH", "USERPROFILE", "HOME", "SYSTEMROOT", "TEMP", "TMP"] {
        if let Some(v) = std::env::var_os(k) {
            cmd.env(k, v);
        }
    }
    #[cfg(windows)]
    cmd.creation_flags(0x08000000);
    let mut child = cmd
        .stdin(std::process::Stdio::null())
        .stdout(std::process::Stdio::piped())
        .stderr(std::process::Stdio::piped())
        .kill_on_drop(true)
        .spawn()
        .map_err(|_| "Podman command unavailable")?;
    let mut stdout = child.stdout.take().unwrap().take(limit + 1);
    let mut stderr = child.stderr.take().unwrap().take(limit + 1);
    let mut out = vec![];
    let mut err = vec![];
    let output = tokio::time::timeout(Duration::from_secs(seconds), async {
        let (a, b) = tokio::join!(stdout.read_to_end(&mut out), stderr.read_to_end(&mut err));
        a.map_err(|_| "stdout unavailable")?;
        b.map_err(|_| "stderr unavailable")?;
        if out.len() as u64 > limit || err.len() as u64 > limit {
            return Err("output limit exceeded");
        }
        let status = child
            .wait()
            .await
            .map_err(|_| "Podman status unavailable")?;
        Ok(status.code().unwrap_or(-1))
    })
    .await
    .map_err(|_| "Podman deadline exceeded")?
    .map_err(String::from)?;
    // stderr is not returned to the cockpit; it can contain local deployment details.
    Ok((output, out))
}
