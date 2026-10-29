//! JSONL black-box adapter for the synthetic capability benchmark, not an AGI claim.
//! Only task inputs and tool observations enter this process; scoring stays outside.
#[path = "../eval_learning.rs"]
mod eval_learning;
use serde_json::{json, Value};
use std::io::{self, BufRead, Write};

fn expression(value: &Value) -> Option<i64> {
    if let Some(number) = value.as_i64() {
        return Some(number);
    }
    let a = expression(&value["a"])?;
    let b = expression(&value["b"])?;
    match value["op"].as_str()? {
        "add" => a.checked_add(b),
        "sub" => a.checked_sub(b),
        "mul" => a.checked_mul(b),
        _ => None,
    }
}

fn solve(task: &Value, observations: &[Value]) -> Value {
    match task["domain"].as_str() {
        Some("reasoning") => json!({"answer":expression(&task["expression"])}),
        Some("planning") => {
            let Some(nodes) = task["nodes"].as_array() else {
                return json!({"abstain":true});
            };
            let Some(edges) = task["edges"].as_array() else {
                return json!({"abstain":true});
            };
            let mut remaining: Vec<String> = nodes
                .iter()
                .filter_map(|n| n.as_str().map(str::to_owned))
                .collect();
            let mut ordered: Vec<String> = Vec::new();
            while !remaining.is_empty() {
                let Some(index) = remaining.iter().position(|node| {
                    edges.iter().all(|edge| {
                        edge[1].as_str() != Some(node)
                            || ordered.iter().any(|done| edge[0].as_str() == Some(done))
                    })
                }) else {
                    return json!({"answer":null});
                };
                ordered.push(remaining.remove(index));
            }
            json!({"answer":ordered})
        }
        Some("learning") => json!({"answer":eval_learning::predict(task)}),
        Some("tools") => {
            let Some(keys) = task["keys"].as_array() else {
                return json!({"abstain":true});
            };
            if observations.len() < keys.len() {
                return json!({"tool":"read","key":keys[observations.len()]});
            }
            if observations.len() == keys.len() {
                let values: Vec<Value> = observations.iter().map(|v| v["result"].clone()).collect();
                return json!({"tool":"calculate","operation":task["operation"],"values":values});
            }
            json!({"answer":observations.last().map(|v| v["result"].clone())})
        }
        _ => json!({"abstain":true}),
    }
}

fn main() {
    println!("{}", json!({"ready":"arkhe-eval-worker/v1"}));
    let _ = io::stdout().flush();
    for line in io::stdin().lock().lines() {
        let Ok(line) = line else { break };
        if line.len() > 32768 {
            break;
        }
        let Ok(input) = serde_json::from_str::<Value>(&line) else {
            break;
        };
        let observations = input["observations"]
            .as_array()
            .cloned()
            .unwrap_or_default();
        println!(
            "{}",
            json!({"id":input["id"],"response":solve(&input["task"],&observations)})
        );
        if io::stdout().flush().is_err() {
            break;
        }
    }
}
