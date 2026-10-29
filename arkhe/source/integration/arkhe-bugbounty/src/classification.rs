//! Explicit severity evidence. A valid classification is not proof of exploitability or scope.
use crate::{ReportDetails, Severity, TriageParams};
use arkhe_core::{canonical::encode_value, Digest32};
use serde::{Deserialize, Serialize};
use std::collections::BTreeMap;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum Domain {
    WebMobile,
    SmartContracts,
    BlockchainProtocols,
}
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum CvssRequirement {
    Optional,
    Required,
    Forbidden,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct TableRow {
    pub id: String,
    pub domain: Domain,
    pub severity: Severity,
}
/// Must be loaded from a trusted governance configuration, never from the report or LLM.
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ClassificationPolicy {
    pub policy_id: String,
    pub version: u64,
    pub web_table_cvss: CvssRequirement,
    pub web_cvss_only: bool,
    pub rows: Vec<TableRow>,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct CvssEvidence {
    pub vector: String,
    /// Integer tenths: 98 means 9.8. Recomputed from the vector before acceptance.
    pub score_tenths: u8,
}
/// Derived output only. Callers cannot supply a decimal string as evidence.
#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
pub struct CvssPresentation {
    pub vector: String,
    pub score_tenths: u8,
    pub score_decimal: String,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "kind", deny_unknown_fields)]
pub enum SeverityBasis {
    HackenProofTable {
        table_row: String,
        cvss: Option<CvssEvidence>,
    },
    CvssFallback {
        cvss: CvssEvidence,
        /// Justification for use without a table; not proof of table coverage or scope.
        rationale: String,
    },
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct TriageAnalysis {
    pub version: u16,
    pub report_digest: Digest32,
    pub parameters_digest: Digest32,
    pub domain: Domain,
    pub proposed_severity: Severity,
    pub basis: SeverityBasis,
}
#[derive(Debug, thiserror::Error, PartialEq, Eq)]
#[error("classification rejected: {0}")]
pub struct ClassificationError(pub &'static str);
type Result<T> = std::result::Result<T, ClassificationError>;
fn ensure(value: bool, message: &'static str) -> Result<()> {
    value.then_some(()).ok_or(ClassificationError(message))
}
fn projection_digest(domain: &[u8], value: &impl Serialize) -> Digest32 {
    // The current canonical encoder accepts integers/strings, not JSON booleans.
    // Serialize the policy boolean into a fixed string in its explicit projection below.
    Digest32::blake3(domain, &encode_value(&serde_json::to_value(value).unwrap()))
}
impl ClassificationPolicy {
    pub fn digest(&self) -> Digest32 {
        projection_digest(
            b"AKG:TRIAGE:CLASSIFICATION-POLICY:v1\0",
            &serde_json::json!({
                "policy_id": self.policy_id, "version": self.version,
                "web_table_cvss": self.web_table_cvss,
                "web_cvss_only": if self.web_cvss_only { "true" } else { "false" },
                "rows": self.rows
            }),
        )
    }
    pub fn validate(&self) -> Result<()> {
        ensure(
            !self.policy_id.trim().is_empty() && self.policy_id.len() <= 128 && self.version > 0,
            "invalid policy identity",
        )?;
        ensure(self.rows.len() <= 512, "table too large")?;
        for (index, row) in self.rows.iter().enumerate() {
            ensure(
                !row.id.trim().is_empty() && row.id.len() <= 128,
                "invalid table row",
            )?;
            ensure(
                !self.rows[..index]
                    .iter()
                    .any(|other| other.domain == row.domain && other.id == row.id),
                "duplicate table row",
            )?;
        }
        Ok(())
    }
}
impl TriageAnalysis {
    pub fn cvss_presentation(&self) -> Result<Option<CvssPresentation>> {
        let cvss = match &self.basis {
            SeverityBasis::HackenProofTable { cvss, .. } => cvss.as_ref(),
            SeverityBasis::CvssFallback { cvss, .. } => Some(cvss),
        };
        cvss.map(|cvss| {
            cvss.validate(self.proposed_severity)?;
            cvss.presentation()
        })
        .transpose()
    }
    pub fn digest(&self) -> Digest32 {
        projection_digest(b"AKG:TRIAGE:CLASSIFICATION:v1\0", self)
    }
    pub fn validate(
        &self,
        report: &ReportDetails,
        params: TriageParams,
        policy: &ClassificationPolicy,
    ) -> Result<()> {
        policy.validate()?;
        ensure(
            self.version == 1 && report.version == 1,
            "unsupported evidence version",
        )?;
        ensure(
            self.report_digest == report.digest() && self.parameters_digest == params.digest(),
            "source or proposal binding mismatch",
        )?;
        ensure(
            self.proposed_severity == params.severity,
            "proposed severity mismatch",
        )?;
        match &self.basis {
            SeverityBasis::HackenProofTable { table_row, cvss } => {
                let row = policy
                    .rows
                    .iter()
                    .find(|row| row.domain == self.domain && &row.id == table_row)
                    .ok_or(ClassificationError("unknown table row or domain"))?;
                ensure(row.severity == params.severity, "table severity mismatch")?;
                if self.domain == Domain::WebMobile {
                    match policy.web_table_cvss {
                        CvssRequirement::Required => {
                            ensure(cvss.is_some(), "CVSS complement required")?
                        }
                        CvssRequirement::Forbidden => {
                            ensure(cvss.is_none(), "CVSS complement forbidden")?
                        }
                        CvssRequirement::Optional => (),
                    }
                } else {
                    ensure(cvss.is_none(), "table plus CVSS is restricted to WebMobile")?;
                }
                if let Some(cvss) = cvss {
                    cvss.validate(params.severity)?;
                }
            }
            SeverityBasis::CvssFallback { cvss, rationale } => {
                ensure(
                    self.domain != Domain::WebMobile || policy.web_cvss_only,
                    "CVSS-only WebMobile disallowed by policy",
                )?;
                ensure(
                    !rationale.trim().is_empty() && rationale.len() <= 4096,
                    "missing or excessive CVSS rationale",
                )?;
                cvss.validate(params.severity)?;
            }
        }
        Ok(())
    }
}
impl CvssEvidence {
    pub fn presentation(&self) -> Result<CvssPresentation> {
        let score = cvss31_base_score(&self.vector)?;
        ensure(
            score == self.score_tenths,
            "CVSS score does not match vector",
        )?;
        Ok(CvssPresentation {
            vector: self.vector.clone(),
            score_tenths: score,
            score_decimal: format!("{}.{:01}", score / 10, score % 10),
        })
    }
    pub fn validate(&self, expected: Severity) -> Result<()> {
        let score = cvss31_base_score(&self.vector)?;
        ensure(
            score == self.score_tenths,
            "CVSS score does not match vector",
        )?;
        ensure(
            score_severity(score) == expected,
            "CVSS severity does not match proposal",
        )
    }
}
pub fn score_severity(score: u8) -> Severity {
    match score {
        0 => Severity::Info,
        1..=39 => Severity::Low,
        40..=69 => Severity::Medium,
        70..=89 => Severity::High,
        _ => Severity::Critical,
    }
}
/// FIRST CVSS 3.1 Base metrics only. Other versions/groups are rejected, never discarded.
pub fn cvss31_base_score(vector: &str) -> Result<u8> {
    ensure(vector.len() <= 128, "CVSS vector too long")?;
    let mut parts = vector.split('/');
    ensure(
        parts.next() == Some("CVSS:3.1"),
        "only CVSS 3.1 Base is supported",
    )?;
    let mut metrics = BTreeMap::new();
    for part in parts {
        let (key, value) = part
            .split_once(':')
            .ok_or(ClassificationError("invalid CVSS metric"))?;
        ensure(
            metrics.insert(key, value).is_none(),
            "duplicate CVSS metric",
        )?;
    }
    ensure(
        metrics.len() == 8
            && ["AV", "AC", "PR", "UI", "S", "C", "I", "A"]
                .iter()
                .all(|key| metrics.contains_key(key)),
        "missing or unsupported CVSS metrics",
    )?;
    let changed = match metrics["S"] {
        "U" => false,
        "C" => true,
        _ => return Err(ClassificationError("invalid CVSS Scope")),
    };
    let weight = |key: &str, values: &[(&str, f64)]| -> Result<f64> {
        values
            .iter()
            .find(|(name, _)| *name == metrics[key])
            .map(|(_, value)| *value)
            .ok_or(ClassificationError("invalid CVSS metric value"))
    };
    let av = weight("AV", &[("N", 0.85), ("A", 0.62), ("L", 0.55), ("P", 0.2)])?;
    let ac = weight("AC", &[("L", 0.77), ("H", 0.44)])?;
    let pr = weight(
        "PR",
        &[
            ("N", 0.85),
            ("L", if changed { 0.68 } else { 0.62 }),
            ("H", if changed { 0.5 } else { 0.27 }),
        ],
    )?;
    let ui = weight("UI", &[("N", 0.85), ("R", 0.62)])?;
    let impacts = [("N", 0.0), ("L", 0.22), ("H", 0.56)];
    let iss = 1.0
        - (1.0 - weight("C", &impacts)?)
            * (1.0 - weight("I", &impacts)?)
            * (1.0 - weight("A", &impacts)?);
    let impact = if changed {
        7.52 * (iss - 0.029) - 3.25 * (iss - 0.02).powi(15)
    } else {
        6.42 * iss
    };
    if impact <= 0.0 {
        return Ok(0);
    }
    let total = (impact + 8.22 * av * ac * pr * ui) * if changed { 1.08 } else { 1.0 };
    Ok(roundup_tenths(total.min(10.0)))
}

/// FIRST Appendix A: nearest integer at 1e-5 precision, then upward rounding.
/// Returns integer tenths; round() alone is deliberately NOT the final score.
fn roundup_tenths(input: f64) -> u8 {
    let scaled = (input * 100000.0).round() as u64;
    scaled.div_ceil(10000) as u8
}

#[cfg(test)]
mod rounding_tests {
    use super::roundup_tenths;
    #[test]
    fn first_appendix_a_roundup_boundaries_and_float_noise() {
        for (input, tenths) in [
            (4.02, 41),
            (4.00, 40),
            (0.0, 0),
            (10.0, 100),
            (9.99999, 100),
            (0.1 + 0.2, 3),
            (4.000000000000001, 40),
            (4.000004, 40),
            (4.000006, 41),
        ] {
            assert_eq!(roundup_tenths(input), tenths, "{input:?}");
        }
        assert_ne!(roundup_tenths(4.02), (4.02_f64 * 10.0).round() as u8);
    }
}
