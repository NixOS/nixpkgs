//! Generate laboratory artifacts only; verification is a separate CLI invocation.
#[path = "../tests/support/gguf_fixture.rs"]
mod fixture;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let destination = std::env::args()
        .nth(1)
        .ok_or("usage: stage10 <new-output-directory>")?;
    // Refuse overwriting an existing artifact set.
    std::fs::create_dir(&destination)?;
    let directory = std::path::Path::new(&destination);
    let (bytes, bundle, trust) = fixture::fixture();
    let report = arkhe_verify_core::gguf::supply_chain::verify(&bytes, &bundle, &trust)?;
    std::fs::write(directory.join("synthetic.gguf"), bytes)?;
    std::fs::write(
        directory.join("bundle.json"),
        serde_json::to_vec_pretty(&bundle)?,
    )?;
    std::fs::write(
        directory.join("trust.lab.json"),
        serde_json::to_vec_pretty(&trust)?,
    )?;
    std::fs::write(
        directory.join("report.json"),
        serde_json::to_vec_pretty(&report)?,
    )?;
    println!("Generated synthetic GGUF, signed bundle, laboratory trust and verified report in {destination}");
    Ok(())
}
