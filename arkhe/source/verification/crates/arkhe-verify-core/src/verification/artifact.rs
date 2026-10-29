use crate::types::VerificationResult;

pub fn result(
    profile: &str,
    valid: bool,
    digest_hex: Option<String>,
    findings: Vec<String>,
) -> VerificationResult {
    VerificationResult {
        valid,
        profile: profile.to_owned(),
        digest_hex,
        findings,
    }
}
