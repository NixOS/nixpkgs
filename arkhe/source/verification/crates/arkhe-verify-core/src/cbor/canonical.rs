use crate::error::VerifyError;
use serde_json::Value;

fn head(major: u8, n: u64, out: &mut Vec<u8>) {
    let base = major << 5;
    match n {
        0..=23 => out.push(base | n as u8),
        24..=0xff => out.extend_from_slice(&[base | 24, n as u8]),
        0x100..=0xffff => {
            out.push(base | 25);
            out.extend_from_slice(&(n as u16).to_be_bytes());
        }
        0x1_0000..=0xffff_ffff => {
            out.push(base | 26);
            out.extend_from_slice(&(n as u32).to_be_bytes());
        }
        _ => {
            out.push(base | 27);
            out.extend_from_slice(&n.to_be_bytes());
        }
    }
}

pub fn encode_json(v: &Value) -> Result<Vec<u8>, VerifyError> {
    let mut out = Vec::new();
    encode_into(v, &mut out)?;
    Ok(out)
}

fn encode_into(v: &Value, out: &mut Vec<u8>) -> Result<(), VerifyError> {
    match v {
        Value::Null => out.push(0xf6),
        Value::Bool(false) => out.push(0xf4),
        Value::Bool(true) => out.push(0xf5),
        Value::Number(n) => {
            if let Some(u) = n.as_u64() {
                head(0, u, out);
            } else if let Some(i) = n.as_i64() {
                if i >= 0 {
                    head(0, i as u64, out);
                } else {
                    head(1, (-1 - i) as u64, out);
                }
            } else {
                return Err(VerifyError::Unsupported(
                    "floating point is outside Phase-1 deterministic subset".into(),
                ));
            }
        }
        Value::String(s) => {
            let b = s.as_bytes();
            head(3, b.len() as u64, out);
            out.extend_from_slice(b);
        }
        Value::Array(a) => {
            head(4, a.len() as u64, out);
            for x in a {
                encode_into(x, out)?;
            }
        }
        Value::Object(m) => {
            let mut pairs = Vec::with_capacity(m.len());
            for (k, v) in m {
                let key = encode_json(&Value::String(k.clone()))?;
                let val = encode_json(v)?;
                pairs.push((key, val));
            }
            pairs.sort_by(|a, b| a.0.cmp(&b.0));
            head(5, pairs.len() as u64, out);
            for (k, v) in pairs {
                out.extend_from_slice(&k);
                out.extend_from_slice(&v);
            }
        }
    }
    Ok(())
}
