//! Program assets come from authenticated program discovery, never the analyzer.
use crate::ReportDetails;
use arkhe_core::{canonical::encode_value, Digest32};
use serde::{Deserialize, Serialize};

#[derive(Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ProgramScope {
    pub version: u16,
    pub program_id: String,
    /// Binds upstream program discovery to this exact report snapshot.
    pub report_digest: Digest32,
    pub included_assets: Vec<Digest32>,
    pub excluded_assets: Vec<Digest32>,
}
impl ProgramScope {
    pub fn check(&self, report: &ReportDetails) -> Result<(), &'static str> {
        if self.version != 1
            || self.program_id.trim().is_empty()
            || self.report_digest != report.digest()
        {
            return Err("invalid or mismatched program scope");
        }
        if report.affected_assets.is_empty()
            || report
                .affected_assets
                .iter()
                .any(|a| !self.included_assets.contains(a) || self.excluded_assets.contains(a))
        {
            return Err("asset absent, excluded or outside program scope");
        }
        Ok(())
    }
    pub fn digest(&self) -> Digest32 {
        Digest32::blake3(
            b"AKG:HACKENPROOF:SCOPE:v1\0",
            &encode_value(&serde_json::to_value(self).expect("scope projection")),
        )
    }
}
