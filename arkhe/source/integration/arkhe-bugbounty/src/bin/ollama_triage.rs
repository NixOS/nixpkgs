//! Generate an untrusted triage assessment from a local report; no external write.
use arkhe_bugbounty::{
    classification::{ClassificationPolicy, TriageAnalysis},
    ollama::OllamaAnalyzer,
    ReportDetails, TriageParams,
};
use arkhe_ollama::{Config, OllamaClient};
#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = std::env::args().skip(1).collect::<Vec<_>>();
    if args.len() != 3 && args.len() != 5 {
        return Err("usage: ollama_triage <report.json> <Critical|High|Medium|Low|Info> <Triaged|Rejected|Duplicate> [analysis.json trusted-policy.json]".into());
    }
    let report: ReportDetails = serde_json::from_slice(&std::fs::read(&args[0])?)?;
    let params = TriageParams {
        severity: serde_json::from_value(serde_json::json!(args[1]))?,
        state: serde_json::from_value(serde_json::json!(args[2]))?,
    };
    let path = std::env::var("ARKHE_OLLAMA_CONFIG").unwrap_or_else(|_| "config/ollama.json".into());
    let mut analyzer = OllamaAnalyzer::new(OllamaClient::new(Config::load(path)?)?);
    let mut cvss = None;
    if args.len() == 5 {
        let analysis: TriageAnalysis = serde_json::from_slice(&std::fs::read(&args[3])?)?;
        let policy: ClassificationPolicy = serde_json::from_slice(&std::fs::read(&args[4])?)?;
        cvss = analysis.cvss_presentation()?;
        analyzer = analyzer.with_classification(analysis, policy)?;
    }
    let (assessment, completion) = analyzer.assess(&report, params).await?;
    println!(
        "{}",
        serde_json::to_string_pretty(
            &serde_json::json!({"status":"UNTRUSTED_PROPOSAL","report_digest":report.digest().to_hex(),"parameters_digest":params.digest().to_hex(),"cvss":cvss,"assessment":assessment,"provider":completion})
        )?
    );
    Ok(())
}
