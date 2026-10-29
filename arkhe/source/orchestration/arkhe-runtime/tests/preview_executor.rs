#[path = "support/preview_fixture.rs"]
mod fixture;
use arkhe_core::Digest32;
use arkhe_runtime::preview::executor::{profile_digest, Qualification, SourceBundle, VECTORS};
use ed25519_dalek::{Signer, SigningKey};
use std::collections::BTreeMap;
#[test]
fn effective_container_policy_rejects_expanded_privileges_limits_and_mounts() {
    use arkhe_runtime::preview::executor::verify_container_policy;
    let (request, _, _) = fixture::fixture(1000);
    let config = serde_json::json!({"Image":request.spec.image,"Config":{"User":"10001:10001","Entrypoint":["cargo"],"Cmd":["test","--locked","--offline","-p","arkhe-agent"],"WorkingDir":"/input"},"Mounts":[{"Type":"bind","Destination":"/input","RW":false}],"HostConfig":{"NetworkMode":"none","ReadonlyRootfs":true,"Privileged":false,"CapAdd":[],"SecurityOpt":["no-new-privileges"],"CapDrop":["CAP_CHOWN","CAP_DAC_OVERRIDE","CAP_FOWNER","CAP_FSETID","CAP_KILL","CAP_NET_BIND_SERVICE","CAP_SETFCAP","CAP_SETGID","CAP_SETPCAP","CAP_SETUID","CAP_SYS_CHROOT"],"Memory":1610612736i64,"MemorySwap":1610612736i64,"PidsLimit":128,"CpuQuota":200000,"CpuPeriod":100000,"Tmpfs":{"/tmp":"rw,noexec,size=67108864","/work":"rw,exec,size=1073741824"}}});
    assert!(verify_container_policy(&config, &request.spec).is_ok());
    for change in 0..7 {
        let mut v = config.clone();
        match change {
            0 => v["HostConfig"]["Memory"] = serde_json::json!(0),
            1 => v["HostConfig"]["Privileged"] = serde_json::json!(true),
            2 => v["Mounts"][0]["RW"] = serde_json::json!(true),
            3 => v["HostConfig"]["CapAdd"] = serde_json::json!(["SYS_ADMIN"]),
            4 => v["Config"]["Cmd"] = serde_json::json!(["test"]),
            5 => v["HostConfig"]["Tmpfs"]["/tmp"] = serde_json::json!("rw,exec"),
            _ => v["Mounts"]
                .as_array_mut()
                .unwrap()
                .push(serde_json::json!({"Destination":"/host","Type":"bind","RW":false})),
        }
        assert!(verify_container_policy(&v, &request.spec).is_err());
    }
}
// These fixtures test enforcement of an external qualification signature. They
// are not an observation, approval, or qualification of a real runtime.
#[test]
fn qualification_rejects_wrong_runtime_expiry_missing_vector_and_forged_signature() {
    let (request, _, _) = fixture::fixture(1000);
    let mut spec = request.spec;
    spec.runtime_profile = profile_digest();
    let key = SigningKey::from_bytes(&[21; 32]);
    let mut q = Qualification {
        version: 1,
        image: spec.image.clone(),
        runtime_profile: profile_digest(),
        engine_identity: fixture::hash(10),
        executor_digest: fixture::hash(11),
        issued_at: 900,
        expires_at: 1100,
        evidence_digest: fixture::hash(12),
        vectors: VECTORS
            .iter()
            .map(|v| (v.to_string(), "PASS".to_string()))
            .collect(),
        signature: String::new(),
    };
    q.signature = hex::encode(key.sign(&q.signing_bytes()).to_bytes());
    assert!(q
        .verify(
            &spec,
            &key.verifying_key().to_bytes(),
            fixture::hash(10),
            fixture::hash(11),
            1000
        )
        .is_ok());
    for mode in 0..7 {
        let mut changed = q.clone();
        match mode {
            0 => changed.image = "sha256:other".into(),
            1 => changed.expires_at = 1000,
            2 => {
                changed.vectors.remove("tmp-noexec");
            }
            3 => {
                changed
                    .vectors
                    .insert("identity".into(), "UNSUPPORTED".into());
            }
            4 => changed.engine_identity = fixture::hash(99),
            5 => changed.executor_digest = fixture::hash(99),
            _ => changed.signature = "00".repeat(64),
        }
        assert!(changed
            .verify(
                &spec,
                &key.verifying_key().to_bytes(),
                fixture::hash(10),
                fixture::hash(11),
                1000
            )
            .is_err());
    }
}
#[test]
fn candidate_bundle_binds_every_source_file_and_limits_mutation_scope() {
    let (request, _, _) = fixture::fixture(1000);
    let mut spec = request.spec;
    let mut bundle = SourceBundle {
        baseline: BTreeMap::from([(
            "Cargo.toml".into(),
            Digest32::blake3(b"", b"[workspace]").to_hex(),
        )]),
        proposal: BTreeMap::from([(
            "cognition/arkhe-agent/src/lib.rs".into(),
            "#[test] fn works() {}".into(),
        )]),
    };
    fn bind(spec: &mut arkhe_runtime::preview::PreviewSpec, b: &SourceBundle) {
        spec.baseline_digest = b.baseline_digest();
        spec.proposal_digest = b.proposal_digest();
        spec.artifact_digest = b.artifact_digest();
    }
    bind(&mut spec, &bundle);
    assert!(bundle.verify(&spec).is_ok());
    bundle
        .proposal
        .values_mut()
        .next()
        .unwrap()
        .push_str("changed");
    assert!(bundle.verify(&spec).is_err());
    for path in [
        "../outside.rs",
        "cognition/arkhe-agent/Cargo.toml",
        "kernel/arkhe-core/src/lib.rs",
        "cognition/arkhe-agent/src/a\\b.rs",
    ] {
        bundle.proposal = BTreeMap::from([(path.into(), "x".into())]);
        bind(&mut spec, &bundle);
        assert!(bundle.verify(&spec).is_err(), "{path}");
    }
}
