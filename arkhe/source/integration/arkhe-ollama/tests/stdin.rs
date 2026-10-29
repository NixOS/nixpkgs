use std::io::Write;
use std::process::{Command, Stdio};
#[test]
fn stdin_rejects_oversized_prompt_before_inference() {
    let config = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../config/ollama.json");
    let mut child = Command::new(env!("CARGO_BIN_EXE_arkhe-ollama"))
        .arg("chat-stdin")
        .env("ARKHE_OLLAMA_CONFIG", config)
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .unwrap();
    child
        .stdin
        .take()
        .unwrap()
        .write_all(&vec![b'x'; 32769])
        .unwrap();
    let output = child.wait_with_output().unwrap();
    assert!(!output.status.success());
    assert!(String::from_utf8_lossy(&output.stderr).contains("prompt exceeds 32 KiB"));
}
