//! Production host factory for migrated legacy dispatch. Registry/policy inputs
//! must come from operator configuration, never the HTTP/model request.
use arkhe_governance::{authenticated::AuthenticatedResolver, PolicyResolver};
use arkhe_kernel::{
    broker::{CapabilityBroker, CapabilityExecutor},
    broker_sqlite::SqliteDispatchJournal,
    ContainmentGate,
};
use arkhe_verify_core::policy::Context;
pub fn open<R: PolicyResolver, X: CapabilityExecutor>(
    resolver: R,
    context: Context,
    path: &std::path::Path,
    executor: X,
) -> Result<CapabilityBroker<AuthenticatedResolver<R>, SqliteDispatchJournal, X>, String> {
    let journal = SqliteDispatchJournal::open(path)?;
    Ok(CapabilityBroker::new(
        ContainmentGate::new(AuthenticatedResolver::new(resolver, context)),
        journal,
        executor,
    ))
}
