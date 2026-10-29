//! Native MMR oracle for the cross-target conformance test; stdin/stdout JSON.
use arkhe_verify_core::mmr::{verify_proof, ProofStep};
use serde::Deserialize;
use serde_json::json;
use std::io::{self, Read};

#[derive(Deserialize)]
struct Case {
    id: String,
    leaf_hex: String,
    leaf_count: usize,
    proof: Vec<ProofStep>,
    root_hex: String,
}

#[derive(Deserialize)]
struct Input {
    cases: Vec<Case>,
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input)?;
    let input: Input = serde_json::from_str(&input)?;
    let mut results = Vec::new();
    for case in input.cases {
        let leaf = hex::decode(case.leaf_hex)?;
        let root: [u8; 32] = hex::decode(case.root_hex)?
            .try_into()
            .map_err(|_| "root must have 32 bytes")?;
        let accepted = verify_proof(&leaf, case.leaf_count, &case.proof, &root).unwrap_or(false);
        results.push(json!({ "id": case.id, "accepted": accepted }));
    }
    println!("{}", json!({ "results": results }));
    Ok(())
}
