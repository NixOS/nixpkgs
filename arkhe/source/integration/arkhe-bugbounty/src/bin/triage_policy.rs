//! Review artifacts and signature verification only; never creates an approval or a root.
use arkhe_bugbounty::{
    classification::ClassificationPolicy,
    governance::{
        now_ms, GovernanceTrustRegistry, RequiredTriageEvidence, SignedTriagePolicyProfile,
        TriagePolicyProfile, VerifiedTriagePolicy,
    },
};
use arkhe_core::Digest32;
#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct DetachedApprovals {
    registry_digest: Digest32,
    approvals: Vec<arkhe_bugbounty::governance::GovernanceApproval>,
}
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<_> = std::env::args().skip(1).collect();
    match args.first().map(String::as_str) {
        Some("prepare") if args.len()==5 => {
            let classification_policy:ClassificationPolicy = serde_json::from_slice(&std::fs::read(&args[1])?)?;
            let seconds:i64=args[4].parse()?;
            if !(1..=86400).contains(&seconds) { return Err("validity must be 1..86400 seconds".into()); }
            let now=now_ms();
            let profile=TriagePolicyProfile {version:1,policy_id:format!("triage:{}",classification_policy.policy_id),policy_version:1,requested_by:args[2].clone(),classification_policy,allowed_modules:vec![args[3].clone()],required_evidence:vec![RequiredTriageEvidence::ClassificationDigest,RequiredTriageEvidence::ClassificationPolicyDigest],valid_from_ms:now,valid_until_ms:now+seconds*1000};
            profile.validate()?;
            let candidate=SignedTriagePolicyProfile {profile,registry_digest:Digest32::ZERO,approvals:vec![]};
            println!("{}",serde_json::to_string_pretty(&serde_json::json!({"status":"UNSIGNED_CANDIDATE_NOT_ACTIVE","profile_digest":candidate.profile.digest().to_hex(),"approval":candidate}))?);
        }
        Some("verify" | "verify-files") if (args[0]=="verify" && args.len()==4) || (args[0]=="verify-files" && args.len()==5) => {
            let (signed,registry_path,pin_index) = if args[0]=="verify" {
                (serde_json::from_slice::<SignedTriagePolicyProfile>(&std::fs::read(&args[1])?)?, &args[2],3)
            } else {
                let profile: TriagePolicyProfile=serde_json::from_slice(&std::fs::read(&args[1])?)?;
                let detached: DetachedApprovals=serde_json::from_slice(&std::fs::read(&args[2])?)?;
                (SignedTriagePolicyProfile {profile,registry_digest:detached.registry_digest,approvals:detached.approvals}, &args[3],4)
            };
            let registry:GovernanceTrustRegistry=serde_json::from_slice(&std::fs::read(registry_path)?)?;
            let raw=hex::decode(&args[pin_index])?;
            let pinned=Digest32(raw.try_into().map_err(|_|"expected a 32-byte independently pinned registry digest")?);
            let policy=VerifiedTriagePolicy::verify(signed,&registry,pinned)?;
            let binding=policy.binding();
            println!("{}",serde_json::to_string_pretty(&serde_json::json!({"status":"QUORUM_VERIFIED_AGAINST_SUPPLIED_PIN","policy_id":binding.policy_id,"version":binding.version,"profile_digest":binding.policy_digest.to_hex(),"classification_policy_digest":policy.classification_policy().digest().to_hex()}))?);
        }
        Some("registry-digest") if args.len()==2 => {
            let registry:GovernanceTrustRegistry=serde_json::from_slice(&std::fs::read(&args[1])?)?;
            println!("{}",serde_json::to_string_pretty(&serde_json::json!({"status":"CONTENT_IDENTITY_ONLY_NOT_APPROVAL_OR_ANCHOR","registry_digest":registry.digest().to_hex()}))?);
        }
        Some("profile-digest") if args.len()==2 => {
            let profile:TriagePolicyProfile=serde_json::from_slice(&std::fs::read(&args[1])?)?;
            profile.validate()?;
            println!("{}",serde_json::to_string_pretty(&serde_json::json!({"status":"CONTENT_IDENTITY_ONLY_NOT_APPROVAL","profile_digest":profile.digest().to_hex()}))?);
        }
        Some("signing-bytes") if args.len()==4 => {
            let profile:TriagePolicyProfile=serde_json::from_slice(&std::fs::read(&args[1])?)?;
            let registry:GovernanceTrustRegistry=serde_json::from_slice(&std::fs::read(&args[2])?)?;
            profile.validate()?;registry.validate()?;
            if !registry.keys.iter().any(|key|key.key_id==args[3]) {return Err("signer is not present in the candidate registry".into());}
            let signed=SignedTriagePolicyProfile {profile,registry_digest:registry.digest(),approvals:vec![]};
            println!("{}",serde_json::to_string_pretty(&serde_json::json!({"status":"BYTES_ONLY_NOT_APPROVAL","key_id":args[3],"profile_digest":signed.profile.digest().to_hex(),"registry_digest":signed.registry_digest.to_hex(),"signing_bytes_hex":hex::encode(signed.signing_bytes(&args[3]))}))?);
        }
        _=>return Err("usage: triage_policy prepare <classification-policy.json> <caller> <module> <valid-seconds> | verify <signed-profile.json> <registry.json> <independent-registry-digest-hex> | verify-files <profile.json> <profile.sig> <registry.json> <independent-registry-digest-hex> | registry-digest <registry.json>".into())
    }
    Ok(())
}
