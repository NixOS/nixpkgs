mod commands;

use clap::{Parser, Subcommand};

#[derive(Parser)]
struct Cli {
    #[command(subcommand)]
    command: Command,
}

#[derive(Subcommand)]
enum Command {
    Migrate,
    ChecksumVerify,
    RlsAudit,
    AppendOnlyAudit,
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let cli = Cli::parse();
    let url = std::env::var("DATABASE_URL")?;
    let pool = sqlx::PgPool::connect(&url).await?;

    match cli.command {
        Command::Migrate => commands::migrate::run(&pool).await?,
        Command::ChecksumVerify => commands::checksum_verify::run(&pool).await?,
        Command::RlsAudit => commands::rls_audit::run(&pool).await?,
        Command::AppendOnlyAudit => commands::append_only_audit::run(&pool).await?,
    }
    Ok(())
}
