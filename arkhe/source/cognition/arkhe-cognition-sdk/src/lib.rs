//! Restricted cognition-facing data and immutable evidence snapshots.
//! This API carries no signing, persistence or authorization capability.
//! A host must authenticate evidence before supplying a snapshot.
#![forbid(unsafe_code)]

pub use arkhe_core::evidence::EvidenceEnvelope;
pub use arkhe_core::{CanonicalEncode, Digest32};
pub mod output_proof {
    pub use arkhe_core::output_proof::*;
}
pub mod formal_proof {
    pub use arkhe_core::formal_proof::*;
}
pub mod worker {
    pub use arkhe_core::worker::WorkerExecutionRecord;
}
pub mod work {
    pub use arkhe_core::work::WorkIntent;
}

mod sealed {
    pub trait Sealed {}
}

/// A sealed description of the only authority available through this SDK.
///
/// ```compile_fail
/// use arkhe_cognition_sdk::CognitionAuthority;
/// struct Elevated;
/// impl CognitionAuthority for Elevated {}
/// ```
pub trait CognitionAuthority: sealed::Sealed {}

/// A marker, never a credential or a proof that arbitrary code is harmless.
/// Its private field prevents callers from forging SDK authority values.
///
/// ```compile_fail
/// use arkhe_cognition_sdk::NoSigningAuthority;
/// let forged = NoSigningAuthority {};
/// ```
#[derive(Debug)]
pub struct NoSigningAuthority {
    _private: (),
}
impl sealed::Sealed for NoSigningAuthority {}
impl CognitionAuthority for NoSigningAuthority {}

/// An owned snapshot, with no callback, database handle or mutable host access.
/// Construction does not verify evidence: admission is the host's responsibility.
/// Duplicate record identities are rejected, including identical duplicates.
///
/// ```compile_fail
/// use arkhe_cognition_sdk::EvidenceReader;
/// let reader = EvidenceReader::from_snapshot(Vec::new()).unwrap();
/// reader.append_verified(todo!());
/// ```
///
/// ```compile_fail
/// use arkhe_cognition_sdk::{EvidenceReader, Digest32};
/// let reader = EvidenceReader::from_snapshot(Vec::new()).unwrap();
/// reader.sign(Digest32::ZERO);
/// ```
///
/// ```compile_fail
/// use arkhe_cognition_sdk::{EvidenceReader, Digest32};
/// let mut reader = EvidenceReader::from_snapshot(Vec::new()).unwrap();
/// reader.get_mut(Digest32::ZERO);
/// ```
///
/// The value returned by `get` cannot be changed through a shared reference.
///
/// ```compile_fail,E0594
/// use arkhe_cognition_sdk::{EvidenceReader, Digest32};
/// fn overwrite_field(reader: &EvidenceReader, id: Digest32) {
///     let evidence = reader.get(id).unwrap();
///     evidence.kind = String::from("forged");
/// }
/// ```
///
/// ```compile_fail,E0594
/// use arkhe_cognition_sdk::{EvidenceReader, EvidenceEnvelope, Digest32};
/// fn replace_record(reader: &EvidenceReader, id: Digest32, other: EvidenceEnvelope) {
///     let evidence = reader.get(id).unwrap();
///     *evidence = other;
/// }
/// ```
///
/// ```compile_fail,E0596
/// use arkhe_cognition_sdk::{EvidenceReader, Digest32};
/// fn mutate_string(reader: &EvidenceReader, id: Digest32) {
///     reader.get(id).unwrap().kind.clear();
/// }
/// ```
///
/// ```compile_fail,E0596
/// use arkhe_cognition_sdk::{EvidenceReader, Digest32};
/// fn mutate_parents(reader: &EvidenceReader, id: Digest32) {
///     reader.get(id).unwrap().causal_parents.push(id);
/// }
/// ```
///
/// Normal shared reads remain available.
///
/// ```
/// use arkhe_cognition_sdk::{EvidenceReader, EvidenceEnvelope, Digest32};
/// let record = EvidenceEnvelope {
///     record_hash: Digest32::ZERO, kind: "observed".into(),
///     subject: Digest32::ZERO, payload_digest: Digest32::ZERO,
///     policy_digest: None, causal_parents: vec![],
/// };
/// let reader = EvidenceReader::from_snapshot(vec![record]).unwrap();
/// assert_eq!(reader.get(Digest32::ZERO).unwrap().kind, "observed");
/// ```
#[derive(Debug)]
pub struct EvidenceReader {
    records: std::collections::HashMap<Digest32, EvidenceEnvelope>,
    authority: NoSigningAuthority,
}
impl EvidenceReader {
    pub fn from_snapshot(records: Vec<EvidenceEnvelope>) -> Result<Self, &'static str> {
        let mut snapshot = std::collections::HashMap::new();
        for record in records {
            if snapshot.insert(record.record_hash, record).is_some() {
                return Err("duplicate evidence identity");
            }
        }
        Ok(Self {
            records: snapshot,
            authority: NoSigningAuthority { _private: () },
        })
    }
    pub fn get(&self, record_hash: Digest32) -> Option<&EvidenceEnvelope> {
        self.records.get(&record_hash)
    }
    pub fn authority(&self) -> &NoSigningAuthority {
        &self.authority
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn evidence() -> EvidenceEnvelope {
        EvidenceEnvelope {
            record_hash: Digest32::ZERO,
            kind: "test".into(),
            subject: Digest32::ZERO,
            payload_digest: Digest32::ZERO,
            policy_digest: None,
            causal_parents: vec![],
        }
    }
    #[test]
    fn snapshot_reads_without_mutating_host_data() {
        let original = evidence();
        let reader = EvidenceReader::from_snapshot(vec![original.clone()]).unwrap();
        assert_eq!(reader.get(original.record_hash), Some(&original));
        assert!(reader.get(Digest32::blake3(b"test", b"missing")).is_none());
        let mut detached = reader.get(original.record_hash).unwrap().clone();
        detached.kind = "changed".into();
        assert_eq!(reader.get(original.record_hash).unwrap().kind, "test");
        fn restricted<T: CognitionAuthority>(_: &T) {}
        restricted(reader.authority());
    }
    // Exhaustive destructuring deliberately breaks if fields are added. The
    // inferred generic type must be one of these exact owned data types; a
    // deref coercion cannot hide an interior-mutable wrapper.
    #[test]
    fn evidence_fields_remain_plain_owned_data() {
        trait PlainField {}
        impl PlainField for String {}
        impl PlainField for Digest32 {}
        impl PlainField for Option<Digest32> {}
        impl PlainField for Vec<Digest32> {}
        fn plain<T: PlainField>(_: &T) {}
        let record = evidence();
        let EvidenceEnvelope {
            record_hash,
            kind,
            subject,
            payload_digest,
            policy_digest,
            causal_parents,
        } = &record;
        plain(record_hash);
        plain(kind);
        plain(subject);
        plain(payload_digest);
        plain(policy_digest);
        plain(causal_parents);
        // Digest32 is itself exhaustively checked down to a byte array.
        let Digest32(bytes) = record.record_hash;
        let _: [u8; 32] = bytes;
    }

    #[test]
    fn conflicting_snapshot_fails_closed() {
        let a = evidence();
        let mut b = a.clone();
        b.kind = "conflict".into();
        assert!(EvidenceReader::from_snapshot(vec![a.clone(), a.clone()]).is_err());
        assert!(EvidenceReader::from_snapshot(vec![a, b]).is_err());
    }
}
