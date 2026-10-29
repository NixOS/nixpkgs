//! Reference affine learner used by the black-box evaluation adapter.
use serde_json::Value;
pub fn predict(task: &Value) -> Option<i64> {
    let examples = task["examples"].as_array()?;
    if examples.len() < 2 {
        return None;
    }
    let (x0, y0, x1, y1, query) = (
        examples[0][0].as_i64()?,
        examples[0][1].as_i64()?,
        examples[1][0].as_i64()?,
        examples[1][1].as_i64()?,
        task["query"].as_i64()?,
    );
    if x1 == x0 || (y1 - y0) % (x1 - x0) != 0 {
        return None;
    }
    let slope = (y1 - y0) / (x1 - x0);
    let intercept = y0 - slope * x0;
    if examples.iter().any(|pair| {
        pair[0]
            .as_i64()
            .zip(pair[1].as_i64())
            .is_none_or(|(x, y)| slope * x + intercept != y)
    }) {
        return None;
    }
    Some(slope * query + intercept)
}
