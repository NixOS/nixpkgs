//! Proposed Unity transport summary v1; not the backend replay summary or verifier ABI.
use crate::{CanonicalEncode, Digest32};
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct MatchSummary {
    pub version: u8,
    pub session_id: Digest32,
    pub player_id: Digest32,
    pub stage_seed: Digest32,
    pub input_digest: Digest32,
    pub state_hash: Digest32,
    pub survival_ms: u32,
    pub projectiles_absorbed: u32,
    pub waves_cleared: u16,
    pub bosses_defeated: u16,
    pub final_score: u64,
}

impl MatchSummary {
    /// Envelope constraints mirrored from Unity's MatchSubmissionGate.
    pub fn validate(&self) -> Result<(), &'static str> {
        if self.version != 1 {
            return Err("unsupported MatchSummary version");
        }
        if self.survival_ms == 0 || self.survival_ms > 1_800_000 {
            return Err("survival_ms outside Unity envelope bounds");
        }
        Ok(())
    }
}

impl CanonicalEncode for MatchSummary {
    const DOMAIN_OBJECT: &'static [u8] = b"AKG:MATCH_SUMMARY:v1\0";

    fn unsigned_projection(&self) -> serde_json::Value {
        serde_json::to_value(self).expect("typed MatchSummary")
    }

    fn canonical_bytes(&self) -> Vec<u8> {
        let mut fields = self.unsigned_projection().as_object().unwrap().clone();
        for name in [
            "session_id",
            "player_id",
            "stage_seed",
            "input_digest",
            "state_hash",
        ] {
            fields.remove(name);
        }
        crate::canonical::encode_map_with_bytes(
            &fields,
            &[
                ("session_id", &self.session_id.0),
                ("player_id", &self.player_id.0),
                ("stage_seed", &self.stage_seed.0),
                ("input_digest", &self.input_digest.0),
                ("state_hash", &self.state_hash.0),
            ],
        )
        .expect("unique typed digest fields")
    }
}
