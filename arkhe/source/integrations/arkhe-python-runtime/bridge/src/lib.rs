//! Import-free ABI for Python/Wasmtime, sharing the existing Rust MMR verifier.
use arkhe_verify_core::mmr::{verify_proof, ProofStep};
use serde::Deserialize;

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct Request {
    leaf: Vec<u8>,
    leaf_count: u32,
    proof: Vec<ProofStep>,
    root: [u8; 32],
}

pub fn verify_json(bytes: &[u8]) -> i32 {
    let Ok(request) = serde_json::from_slice::<Request>(bytes) else {
        return -1;
    };
    match verify_proof(
        &request.leaf,
        request.leaf_count as usize,
        &request.proof,
        &request.root,
    ) {
        Ok(true) => 1,
        Ok(false) => 0,
        Err(_) => -1,
    }
}

// Each Python call creates a fresh single-threaded instance. The host owns writes
// before verification; no borrowed view escapes this function or overlaps a write.
#[cfg(target_arch = "wasm32")]
mod abi {
    const CAPACITY: usize = 65_536;
    static mut INPUT: [u8; CAPACITY] = [0; CAPACITY];

    #[no_mangle]
    pub extern "C" fn arkhe_abi_version() -> u32 {
        1
    }
    #[no_mangle]
    pub extern "C" fn arkhe_input_ptr() -> *mut u8 {
        core::ptr::addr_of_mut!(INPUT).cast::<u8>()
    }
    #[no_mangle]
    pub extern "C" fn arkhe_input_capacity() -> usize {
        CAPACITY
    }
    #[no_mangle]
    pub extern "C" fn arkhe_verify_mmr(length: usize) -> i32 {
        if length > CAPACITY {
            return -1;
        }
        // SAFETY: the fixed buffer is initialized and length is bounded above.
        let bytes = unsafe { core::slice::from_raw_parts(arkhe_input_ptr(), length) };
        super::verify_json(bytes)
    }
}

#[cfg(test)]
mod tests {
    #[test]
    fn real_proof_and_tampering() {
        let leaves = vec![b"one".to_vec(), b"two".to_vec(), b"three".to_vec()];
        let (root, proof) = arkhe_verify_core::mmr::build_root_and_proof(&leaves, 1).unwrap();
        let mut request =
            serde_json::json!({"leaf": leaves[1], "leaf_count": 3, "proof": proof, "root": root});
        assert_eq!(
            super::verify_json(&serde_json::to_vec(&request).unwrap()),
            1
        );
        request["leaf"] = serde_json::json!([0]);
        assert_eq!(
            super::verify_json(&serde_json::to_vec(&request).unwrap()),
            0
        );
        assert_eq!(super::verify_json(b"{}"), -1);
    }
}
