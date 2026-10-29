//! Local evidence consistency check only; no model, admission, or external action.
use arkhe_bugbounty::{
    classification::{ClassificationPolicy, TriageAnalysis},
    ReportDetails, TriageParams,
};
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<_> = std::env::args().skip(1).collect();
    if args.len() != 5 {
        return Err("usage: validate_triage <report.json> <analysis.json> <trusted-policy.json> <Critical|High|Medium|Low|Info> <Triaged|Rejected|Duplicate>".into());
    }
    let report: ReportDetails = serde_json::from_slice(&std::fs::read(&args[0])?)?;
    let analysis: TriageAnalysis = serde_json::from_slice(&std::fs::read(&args[1])?)?;
    let policy: ClassificationPolicy = serde_json::from_slice(&std::fs::read(&args[2])?)?;
    let params = TriageParams {
        severity: serde_json::from_value(serde_json::json!(args[3]))?,
        state: serde_json::from_value(serde_json::json!(args[4]))?,
    };
    analysis.validate(&report, params, &policy)?;
    let classification = arkhe_core::worker::ClassificationBinding {
        classification_digest: analysis.digest(),
        policy_digest: policy.digest(),
    };
    println!(
        "{}",
        serde_json::to_string_pretty(&serde_json::json!({
            "status":"CONSISTENT_UNTRUSTED_PROPOSAL", "classification_digest":analysis.digest().to_hex(),
            "policy_digest":policy.digest().to_hex(), "report_digest":report.digest().to_hex(),
            "parameters_digest":params.digest().to_hex(), "classified_parameters_digest":params.digest_for(Some(classification)).to_hex(),
            "classification_binding":classification, "cvss":analysis.cvss_presentation()?
        }))?
    );
    Ok(())
}
