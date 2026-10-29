use arkhe_core::Digest32;

#[derive(Debug, Clone)]
pub struct EmergencyProcedure {
    pub procedure_id: Digest32,
    pub transition: String,
    pub policy_digest: Digest32,
    pub required_quorum: usize,
    pub authorized_operators: Vec<String>,
    pub not_before: i64,
    pub not_after: i64,
    pub replay_nonce: Digest32,
}

pub fn unique_authorized_quorum(p: &EmergencyProcedure, signer_ids: &[String]) -> bool {
    let mut unique = signer_ids.to_vec();
    unique.sort();
    unique.dedup();
    unique.len() >= p.required_quorum && unique.iter().all(|s| p.authorized_operators.contains(s))
}
