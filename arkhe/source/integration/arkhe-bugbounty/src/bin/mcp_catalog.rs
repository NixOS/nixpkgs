//! Authenticated read-only catalog discovery; candidate pins require explicit review.
use arkhe_bugbounty::mcp::AuthenticatedMcp;
#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let output = std::env::args().nth(1).ok_or("output path required")?;
    let endpoint = std::env::var("HACKENPROOF_MCP_URL")
        .unwrap_or_else(|_| "https://mcp.hackenproof.com/mcp".into());
    let key = std::env::var("HACKENPROOF_API_KEY")
        .map_err(|_| "HACKENPROOF_API_KEY is unavailable; inject it from a secret manager")?;
    let catalog = AuthenticatedMcp::inspect_catalog(&endpoint, &key).await?;
    std::fs::write(output, serde_json::to_vec_pretty(&catalog)?)?;
    println!("Saved untrusted catalog candidate for review");
    Ok(())
}
