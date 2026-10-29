use sha2::{Digest, Sha384};
use sqlx::PgPool;
use std::path::PathBuf;

pub async fn run(pool: &PgPool) -> anyhow::Result<()> {
    let rows: Vec<(i64, Vec<u8>)> =
        sqlx::query_as("SELECT version, checksum FROM _sqlx_migrations ORDER BY version")
            .fetch_all(pool)
            .await?;

    for (version, stored) in rows {
        let prefix = version.to_string();
        let mut found: Option<PathBuf> = None;
        for entry in std::fs::read_dir("migrations")? {
            let path = entry?.path();
            if path
                .file_name()
                .and_then(|n| n.to_str())
                .map(|n| n.starts_with(&prefix) && n.ends_with(".sql"))
                .unwrap_or(false)
            {
                found = Some(path);
                break;
            }
        }

        let path = found.ok_or_else(|| anyhow::anyhow!("missing migration file for {version}"))?;
        let bytes = tokio::fs::read(&path).await?;
        let digest = Sha384::digest(bytes);

        anyhow::ensure!(
            stored.as_slice() == &digest[..],
            "migration checksum mismatch for {} ({})",
            version,
            path.display()
        );
    }

    Ok(())
}
