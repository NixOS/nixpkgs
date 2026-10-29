use async_trait::async_trait;

#[async_trait]
pub trait AppendOnlyRepository<T> {
    type Key;
    async fn insert(&self, value: &T) -> Result<Self::Key, sqlx::Error>;
}
