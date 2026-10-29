use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EmployeeIdentity {
    pub did: String,
    pub work_public_key: Vec<u8>,
    pub privacy_key_ref: String,
    pub active: bool,
}
