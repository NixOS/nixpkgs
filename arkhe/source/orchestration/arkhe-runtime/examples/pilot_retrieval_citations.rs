//! Structured citation CLI; implementation shared with the native WER bridge.
#[path = "support/retrieval_citations.rs"]
mod retrieval_citations;
use std::io::{self, Read};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut bytes = vec![];
    io::stdin().take(1_200_001).read_to_end(&mut bytes)?;
    if bytes.len() > 1_200_000 {
        return Err("input too large".into());
    }
    let result = retrieval_citations::verify_value(serde_json::from_slice(&bytes)?)
        .map_err(io::Error::other)?;
    println!("{}", serde_json::to_string(&result)?);
    Ok(())
}
