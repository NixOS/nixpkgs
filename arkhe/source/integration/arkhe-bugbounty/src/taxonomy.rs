//! Educational topic index, never an activated severity policy. Many engineering topics
//! are not vulnerabilities and deliberately have no CWE or HackenProof table mapping.
use crate::{classification::Domain, Severity};
use serde::Deserialize;

#[derive(Deserialize)]
pub struct Topic {
    pub id: u16,
    pub title: String,
    pub cwe: Option<String>,
    pub hackenproof_basis: Vec<TableReference>,
}
#[derive(Deserialize)]
pub struct TableReference {
    pub domain: Domain,
    pub typical_severity: Severity,
    pub table_row: String,
    pub source: String,
}
pub fn topics() -> Result<Vec<Topic>, serde_json::Error> {
    serde_json::from_str(include_str!("../config/topics.json"))
}

#[cfg(test)]
mod tests {
    #[test]
    fn catalogue_has_all_user_topics_without_inventing_severity_for_engineering() {
        let topics = super::topics().unwrap();
        assert_eq!(topics.len(), 250);
        for (i, topic) in topics.iter().enumerate() {
            assert_eq!(topic.id as usize, i + 1);
        }
        assert_eq!(topics[1].hackenproof_basis.len(), 2); // XSS is not one fixed severity.
        assert!(topics[40].hackenproof_basis.is_empty()); // Indexes are not vulnerabilities.
    }
}
