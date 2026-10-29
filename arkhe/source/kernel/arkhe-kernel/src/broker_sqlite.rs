//! Optional standalone durable broker journal. Does not replace PostgreSQL.
use crate::broker::{DispatchJournal, Reservation};
use arkhe_core::Digest32;
use rusqlite::{params, Connection, OptionalExtension, TransactionBehavior};
use std::{collections::HashMap, path::Path, time::Duration};

pub struct SqliteDispatchJournal {
    connection: Connection,
    owners: HashMap<(String, Digest32), String>,
}
#[derive(Debug, PartialEq, Eq)]
pub enum TransactionalResult {
    Executed(Vec<u8>),
    Replay(Vec<u8>),
    Uncertain,
}

impl SqliteDispatchJournal {
    /// Atomic only for effects written through this same SQLite transaction.
    /// The trusted callback MUST NOT perform network/filesystem/provider effects.
    /// On callback error/panic the local effect, nonce and reservation roll back.
    pub fn transact_authenticated<F>(
        &mut self,
        caller: &str,
        operation: Digest32,
        binding: Digest32,
        nonce: Digest32,
        effect: F,
    ) -> Result<TransactionalResult, String>
    where
        F: FnOnce(&rusqlite::Transaction<'_>) -> Result<Vec<u8>, String>,
    {
        let tx = self
            .connection
            .transaction_with_behavior(TransactionBehavior::Immediate)
            .map_err(|e| e.to_string())?;
        let old:Option<(Vec<u8>,String,Option<Vec<u8>>)>=tx.query_row("SELECT binding,status,receipt FROM broker_dispatch WHERE caller=?1 AND operation=?2",params![caller,&operation.0[..]],|r|Ok((r.get(0)?,r.get(1)?,r.get(2)?))).optional().map_err(|e|e.to_string())?;
        if let Some((old, status, receipt)) = old {
            if old != binding.0 {
                return Err("broker parameter/policy conflict".into());
            }
            let same:bool=tx.query_row("SELECT EXISTS(SELECT 1 FROM broker_authenticated_consumption WHERE caller=?1 AND nonce=?2 AND operation=?3)",params![caller,&nonce.0[..],&operation.0[..]],|r|r.get(0)).map_err(|e|e.to_string())?;
            if !same {
                return Err("authenticated nonce binding missing".into());
            }
            return match (status.as_str(), receipt) {
                ("COMPLETED", Some(r)) => Ok(TransactionalResult::Replay(r)),
                ("UNCERTAIN", None) => Ok(TransactionalResult::Uncertain),
                _ => Err("invalid persisted broker state".into()),
            };
        }
        let owner = uuid::Uuid::new_v4().to_string();
        tx.execute("INSERT INTO broker_dispatch(caller,operation,binding,owner,status) VALUES(?1,?2,?3,?4,'UNCERTAIN')",params![caller,&operation.0[..],&binding.0[..],owner]).map_err(|e|e.to_string())?;
        tx.execute(
            "INSERT INTO broker_authenticated_consumption(caller,nonce,operation) VALUES(?1,?2,?3)",
            params![caller, &nonce.0[..], &operation.0[..]],
        )
        .map_err(|_| "authenticated nonce already consumed".to_owned())?;
        let receipt = effect(&tx)?;
        let n=tx.execute("UPDATE broker_dispatch SET status='COMPLETED',receipt=?4 WHERE caller=?1 AND operation=?2 AND binding=?3 AND status='UNCERTAIN'",params![caller,&operation.0[..],&binding.0[..],&receipt]).map_err(|e|e.to_string())?;
        if n != 1 {
            return Err("invalid transactional completion".into());
        }
        tx.commit().map_err(|e| e.to_string())?;
        Ok(TransactionalResult::Executed(receipt))
    }
}
impl SqliteDispatchJournal {
    pub fn open(path: &Path) -> Result<Self, String> {
        if path == Path::new(":memory:") || path.as_os_str().is_empty() {
            return Err("durable broker requires a filesystem database".into());
        }
        let connection = Connection::open(path).map_err(|e| e.to_string())?;
        connection
            .busy_timeout(Duration::from_secs(5))
            .map_err(|e| e.to_string())?;
        connection
            .execute_batch(
                "PRAGMA journal_mode=WAL; PRAGMA synchronous=FULL;
          CREATE TABLE IF NOT EXISTS broker_dispatch(
            caller TEXT NOT NULL, operation BLOB NOT NULL, binding BLOB NOT NULL,
            owner TEXT NOT NULL, status TEXT NOT NULL CHECK(status IN ('UNCERTAIN','COMPLETED')),
            receipt BLOB, PRIMARY KEY(caller,operation),
            CHECK((status='COMPLETED')=(receipt IS NOT NULL)));
          CREATE TABLE IF NOT EXISTS broker_closed_consumption(
            closed BLOB PRIMARY KEY NOT NULL, caller TEXT NOT NULL, operation BLOB NOT NULL);
          CREATE TABLE IF NOT EXISTS broker_authenticated_consumption(
            caller TEXT NOT NULL, nonce BLOB NOT NULL, operation BLOB NOT NULL, PRIMARY KEY(caller,nonce));",
            )
            .map_err(|e| e.to_string())?;
        Ok(Self {
            connection,
            owners: HashMap::new(),
        })
    }
    fn reserve_inner(
        &mut self,
        caller: &str,
        operation: Digest32,
        binding: Digest32,
        closed: Option<Digest32>,
        nonce: Option<Digest32>,
    ) -> Result<Reservation, String> {
        let tx = self
            .connection
            .transaction_with_behavior(TransactionBehavior::Immediate)
            .map_err(|e| e.to_string())?;
        let old: Option<(Vec<u8>,String,Option<Vec<u8>>)> = tx.query_row(
            "SELECT binding,status,receipt FROM broker_dispatch WHERE caller=?1 AND operation=?2",
            params![caller,&operation.0[..]], |r| Ok((r.get(0)?,r.get(1)?,r.get(2)?))).optional().map_err(|e|e.to_string())?;
        if let Some((old, status, receipt)) = old {
            if old != binding.0 {
                return Err("broker parameter/policy conflict".into());
            }
            if let Some(closed) = closed {
                let same:bool=tx.query_row("SELECT EXISTS(SELECT 1 FROM broker_closed_consumption WHERE closed=?1 AND caller=?2 AND operation=?3)",
                    params![&closed.0[..],caller,&operation.0[..]],|r|r.get(0)).map_err(|e|e.to_string())?;
                if !same {
                    return Err("closed-mandate consumption binding missing".into());
                }
            }
            if let Some(nonce) = nonce {
                let same:bool=tx.query_row("SELECT EXISTS(SELECT 1 FROM broker_authenticated_consumption WHERE caller=?1 AND nonce=?2 AND operation=?3)",params![caller,&nonce.0[..],&operation.0[..]],|r|r.get(0)).map_err(|e|e.to_string())?;
                if !same {
                    return Err("authenticated nonce binding missing".into());
                }
            }
            let result = match (status.as_str(), receipt) {
                ("COMPLETED", Some(receipt)) => Reservation::Replay(receipt),
                ("UNCERTAIN", None) => Reservation::Uncertain,
                _ => return Err("invalid persisted broker state".into()),
            };
            tx.commit().map_err(|e| e.to_string())?;
            return Ok(result);
        }
        let owner = uuid::Uuid::new_v4().to_string();
        tx.execute("INSERT INTO broker_dispatch(caller,operation,binding,owner,status) VALUES(?1,?2,?3,?4,'UNCERTAIN')",
            params![caller,&operation.0[..],&binding.0[..],owner]).map_err(|e|e.to_string())?;
        if let Some(closed) = closed {
            tx.execute(
                "INSERT INTO broker_closed_consumption(closed,caller,operation) VALUES(?1,?2,?3)",
                params![&closed.0[..], caller, &operation.0[..]],
            )
            .map_err(|_| "closed mandate already consumed".to_owned())?;
        }
        if let Some(nonce) = nonce {
            tx.execute("INSERT INTO broker_authenticated_consumption(caller,nonce,operation) VALUES(?1,?2,?3)",params![caller,&nonce.0[..],&operation.0[..]])
                .map_err(|_|"authenticated nonce already consumed".to_owned())?;
        }
        tx.commit().map_err(|e| e.to_string())?;
        self.owners.insert((caller.into(), operation), owner);
        Ok(Reservation::Acquired)
    }
}
impl DispatchJournal for SqliteDispatchJournal {
    fn reserve_authenticated(
        &mut self,
        caller: &str,
        operation: Digest32,
        binding: Digest32,
        nonce: Digest32,
    ) -> Result<Reservation, String> {
        self.reserve_inner(caller, operation, binding, None, Some(nonce))
    }
    fn reserve(
        &mut self,
        caller: &str,
        operation: Digest32,
        binding: Digest32,
    ) -> Result<Reservation, String> {
        self.reserve_inner(caller, operation, binding, None, None)
    }
    fn reserve_payment(
        &mut self,
        caller: &str,
        operation: Digest32,
        binding: Digest32,
        closed: Digest32,
    ) -> Result<Reservation, String> {
        self.reserve_inner(caller, operation, binding, Some(closed), None)
    }
    fn complete(
        &mut self,
        caller: &str,
        operation: Digest32,
        binding: Digest32,
        receipt: &[u8],
    ) -> Result<(), String> {
        let slot = (caller.into(), operation);
        let owner = self
            .owners
            .get(&slot)
            .ok_or("journal handle does not own reservation")?;
        let n=self.connection.execute("UPDATE broker_dispatch SET status='COMPLETED',receipt=?5 WHERE caller=?1 AND operation=?2 AND binding=?3 AND owner=?4 AND status='UNCERTAIN'",
            params![caller,&operation.0[..],&binding.0[..],owner,receipt]).map_err(|e|e.to_string())?;
        if n != 1 {
            return Err("invalid broker completion transition".into());
        }
        self.owners.remove(&slot);
        Ok(())
    }
}
