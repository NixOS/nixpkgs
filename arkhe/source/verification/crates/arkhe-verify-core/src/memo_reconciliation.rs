//! Independently decode a bounded direct Memo -> USDC transfer() observation.
//! Raw RPC assertions are evidence inputs, not authenticated consensus proofs.
use crate::reconciliation::{self, Bundle, Decision, Transfer, Trust};
use arkhe_core::{canonical::encode_value, Digest32};
use serde::{Deserialize, Serialize};
use serde_json::Value;
use sha3::{Digest, Keccak256};

const MEMO: &str = "0x5294e9927c3306dcbadb03fe70b92e01ccede505";
const SYSTEM: &str = "0xfffffffffffffffffffffffffffffffffffffffe";
const USDC: &str = "0x3600000000000000000000000000000000000000";
const TRANSFER_TOPIC: &str = "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef";
const MEMO_TOPIC: &str = "0xeb15ee720798341c37739df41be53acfbbf70ae6802dade35457beec6e47a5e4";
const BEFORE_TOPIC: &str = "0xb252e055da754c72fbf7542cf424b190808a9b541e912894c5e15b4238c41501";
const SCALE: u128 = 1_000_000_000_000;

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct MemoEvidence {
    pub profile: String,
    pub chain_response: Vec<u8>,
    pub receipt_response: Vec<u8>,
    pub block_response: Vec<u8>,
    pub finalized_response: Vec<u8>,
}

impl MemoEvidence {
    fn bounded(&self) -> Result<(), &'static str> {
        if self.profile != "arkhe/arc-direct-memo-evidence/v1"
            || [
                &self.chain_response,
                &self.receipt_response,
                &self.block_response,
                &self.finalized_response,
            ]
            .iter()
            .any(|v| v.is_empty() || v.len() > 1_000_000)
        {
            return Err("invalid or oversized memo evidence");
        }
        Ok(())
    }
    pub fn commitment(&self) -> Result<Digest32, &'static str> {
        self.bounded()?;
        Ok(Digest32::blake3(
            b"AKG:ARC:DIRECT-MEMO-EVIDENCE:v1\0",
            &encode_value(&serde_json::to_value(self).map_err(|_| "memo encoding failed")?),
        ))
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct MemoBundle {
    pub reconciliation: Bundle,
    pub evidence: MemoEvidence,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MemoObservation {
    pub transfer: Transfer,
    pub memo_id: String,
    pub memo_hex: String,
    pub call_data_hash: String,
    pub finalized_head_number: u64,
}

fn result(raw: &[u8]) -> Result<Value, &'static str> {
    let v: Value = serde_json::from_slice(raw).map_err(|_| "invalid RPC JSON")?;
    if v["jsonrpc"] != "2.0"
        || v["id"].as_u64().is_none()
        || v.get("error").is_some()
        || v.get("result").is_none_or(Value::is_null)
    {
        return Err("invalid RPC envelope");
    }
    Ok(v["result"].clone())
}
fn text(v: &Value) -> Result<&str, &'static str> {
    v.as_str().ok_or("missing string field")
}
fn hex_bytes(v: &Value, size: usize) -> Result<Vec<u8>, &'static str> {
    let s = text(v)?;
    if !s.starts_with("0x") || s.len() != 2 + size * 2 {
        return Err("invalid hex width");
    }
    hex::decode(&s[2..]).map_err(|_| "invalid hex bytes")
}
fn normalized(v: &Value, size: usize) -> Result<String, &'static str> {
    Ok(format!("0x{}", hex::encode(hex_bytes(v, size)?)))
}
fn quantity(v: &Value) -> Result<u64, &'static str> {
    let s = text(v)?.strip_prefix("0x").ok_or("invalid hex quantity")?;
    if s.is_empty() || s.len() > 16 || !s.bytes().all(|c| c.is_ascii_hexdigit()) {
        return Err("invalid or excessive hex quantity");
    }
    u64::from_str_radix(s, 16).map_err(|_| "quantity overflow")
}
fn small_word(word: &[u8]) -> Result<u128, &'static str> {
    if word.len() != 32 || word[..16].iter().any(|b| *b != 0) {
        return Err("ABI integer too large");
    }
    Ok(u128::from_be_bytes(
        word[16..].try_into().map_err(|_| "invalid ABI word")?,
    ))
}
fn topic_address(v: &Value) -> Result<String, &'static str> {
    let bytes = hex_bytes(v, 32)?;
    if bytes[..12].iter().any(|b| *b != 0) {
        return Err("invalid indexed address padding");
    }
    Ok(format!("0x{}", hex::encode(&bytes[12..])))
}
fn log_index(log: &Value) -> Result<u64, &'static str> {
    quantity(&log["logIndex"])
}

/// Supported subset: one direct Memo frame, one native transfer and its ERC-20
/// mirror. Multiple/nested calls fail closed rather than guessing correlation.
pub fn observe(e: &MemoEvidence) -> Result<MemoObservation, &'static str> {
    e.bounded()?;
    if quantity(&result(&e.chain_response)?)? != 5042002 {
        return Err("wrong memo network");
    }
    let receipt = result(&e.receipt_response)?;
    let block = result(&e.block_response)?;
    let finalized = result(&e.finalized_response)?;
    let tx = normalized(&receipt["transactionHash"], 32)?;
    let block_hash = normalized(&receipt["blockHash"], 32)?;
    let block_number = quantity(&receipt["blockNumber"])?;
    let transaction_index = quantity(&receipt["transactionIndex"])?;
    let finalized_number = quantity(&finalized["number"])?;
    normalized(&finalized["hash"], 32)?;
    if quantity(&receipt["status"])? != 1
        || normalized(&receipt["to"], 20)? != MEMO
        || normalized(&block["hash"], 32)? != block_hash
        || quantity(&block["number"])? != block_number
        || block_number > finalized_number
    {
        return Err("receipt/block/finality inconsistency");
    }
    let transactions = block["transactions"]
        .as_array()
        .ok_or("missing block transactions")?;
    let position = usize::try_from(transaction_index).map_err(|_| "transaction index overflow")?;
    if transactions
        .get(position)
        .and_then(Value::as_str)
        .map(str::to_lowercase)
        .as_deref()
        != Some(tx.as_str())
        || (block_number == finalized_number && normalized(&finalized["hash"], 32)? != block_hash)
    {
        return Err("receipt transaction absent from supplied block");
    }
    let logs = receipt["logs"].as_array().ok_or("missing receipt logs")?;
    if logs.len() > 2048 {
        return Err("too many receipt logs");
    }
    let mut before = Vec::new();
    let mut memos = Vec::new();
    let mut movements = Vec::new();
    let mut mirrors = Vec::new();
    let mut indices = std::collections::BTreeSet::new();
    for log in logs {
        let address = normalized(&log["address"], 20)?;
        if !matches!(address.as_str(), MEMO | SYSTEM | USDC) {
            continue;
        }
        if log["removed"] != false
            || normalized(&log["blockHash"], 32)? != block_hash
            || normalized(&log["transactionHash"], 32)? != tx
            || quantity(&log["blockNumber"])? != block_number
            || quantity(&log["transactionIndex"])? != transaction_index
            || !indices.insert(log_index(log)?)
        {
            return Err("log provenance or index mismatch");
        }
        let topics = log["topics"].as_array().ok_or("missing event topics")?;
        let topic = normalized(topics.first().ok_or("empty topics")?, 32)?;
        match (address.as_str(), topic.as_str()) {
            (MEMO, BEFORE_TOPIC) => before.push(log),
            (MEMO, MEMO_TOPIC) => memos.push(log),
            (SYSTEM, TRANSFER_TOPIC) => movements.push(log),
            (USDC, TRANSFER_TOPIC) => mirrors.push(log),
            _ => {}
        }
    }
    if before.len() != 1 || memos.len() != 1 || movements.len() != 1 || mirrors.len() != 1 {
        return Err("unsupported or ambiguous memo frame");
    }
    let (b, m, t, mirror) = (before[0], memos[0], movements[0], mirrors[0]);
    if b["topics"].as_array().map(Vec::len) != Some(2)
        || text(&b["data"])? != "0x"
        || m["topics"].as_array().map(Vec::len) != Some(4)
        || t["topics"].as_array().map(Vec::len) != Some(3)
        || mirror["topics"].as_array().map(Vec::len) != Some(3)
        || !(log_index(b)? < log_index(t)?
            && log_index(t)? < log_index(mirror)?
            && log_index(mirror)? < log_index(m)?)
    {
        return Err("invalid memo frame ordering or shape");
    }
    let data_str = text(&m["data"])?;
    if !data_str.starts_with("0x") || data_str.len() > 2 + 2 * (128 + 4096) {
        return Err("invalid memo data size");
    }
    let data = hex::decode(&data_str[2..]).map_err(|_| "invalid memo ABI hex")?;
    if data.len() < 128 || small_word(&data[32..64])? != 96 {
        return Err("invalid memo ABI offset");
    }
    let len = usize::try_from(small_word(&data[96..128])?).map_err(|_| "memo length overflow")?;
    if len > 4096
        || data.len() != 128 + len.div_ceil(32) * 32
        || data[128 + len..].iter().any(|b| *b != 0)
        || hex_bytes(&b["topics"][1], 32)? != data[64..96]
    {
        return Err("invalid memo length/padding/frame index");
    }
    let payer = topic_address(&t["topics"][1])?;
    let payee = topic_address(&t["topics"][2])?;
    if normalized(&receipt["from"], 20)? != payer
        || topic_address(&m["topics"][1])? != payer
        || topic_address(&m["topics"][2])? != USDC
        || topic_address(&mirror["topics"][1])? != payer
        || topic_address(&mirror["topics"][2])? != payee
        || payer == format!("0x{}", "00".repeat(20))
        || payee == format!("0x{}", "00".repeat(20))
    {
        return Err("memo sender/target/transfer parties mismatch");
    }
    let native = small_word(&hex_bytes(&t["data"], 32)?)?;
    let amount = u64::try_from(native / SCALE).map_err(|_| "amount overflow")?;
    if native % SCALE != 0
        || amount == 0
        || small_word(&hex_bytes(&mirror["data"], 32)?)? != u128::from(amount)
    {
        return Err("native/ERC20 amount or precision mismatch");
    }
    let mut calldata = vec![0xa9, 0x05, 0x9c, 0xbb];
    calldata.extend(hex_bytes(&t["topics"][2], 32)?);
    calldata.extend([0u8; 24]);
    calldata.extend(amount.to_be_bytes());
    let hash: [u8; 32] = Keccak256::digest(&calldata).into();
    if data[..32] != hash {
        return Err("memo calldata hash mismatch");
    }
    let memo_id = normalized(&m["topics"][3], 32)?;
    if hex_bytes(&m["topics"][3], 32)?.iter().all(|b| *b == 0) {
        return Err("zero memo ID is not a reference");
    }
    Ok(MemoObservation {
        transfer: Transfer {
            chain_id: 5042002,
            block_number,
            block_hash,
            transaction_hash: tx,
            event_index: u32::try_from(log_index(t)?).map_err(|_| "log index overflow")?,
            from: payer,
            to: payee,
            amount_microusd: amount,
            observed_at: quantity(&block["timestamp"])?,
            reference: format!("arc-memo-id:{memo_id}"),
            source: format!("arc-memo-evidence:blake3:{}", e.commitment()?.to_hex()),
            synthetic: false,
        },
        memo_id,
        memo_hex: format!("0x{}", hex::encode(&data[128..128 + len])),
        call_data_hash: format!("0x{}", hex::encode(hash)),
        finalized_head_number: finalized_number,
    })
}

pub fn verify(bundle: &MemoBundle, trust: &Trust) -> Result<Decision, &'static str> {
    let observation = observe(&bundle.evidence)?;
    if bundle.reconciliation.record.input.transfer != observation.transfer {
        return Err("memo evidence does not derive the exact reconciliation transfer");
    }
    reconciliation::verify(&bundle.reconciliation, trust)
}
