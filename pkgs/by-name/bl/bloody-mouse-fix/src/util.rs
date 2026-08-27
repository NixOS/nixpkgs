use std::fs;
use std::fs::File;
use std::io::Write;
use std::path::Path;

const SERVICE_FILE_PATH: &str = "/etc/systemd/system/mouse_fix.service";

pub fn create_service_file(exec_path: &str) {
    let _ = std::process::Command::new("restorecon")
        .arg(exec_path)
        .output();

    let mut file = File::create(SERVICE_FILE_PATH).expect("Couldn't create service file!");

    let service_content = r#"[Unit]
Description=Fix mouse movement issue

[Service]
User=root
ExecStart=/usr/local/bin/mouse_fix
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
"#;

    file.write_all(service_content.as_bytes()).unwrap();

    std::process::Command::new("systemctl")
        .arg("daemon-reload")
        .output()
        .unwrap();

    std::process::Command::new("systemctl")
        .args(["enable", "mouse_fix"])
        .output()
        .unwrap();

    std::process::Command::new("systemctl")
        .args(["start", "mouse_fix"])
        .output()
        .unwrap();
}

pub fn remove_service_file() {
    if !Path::new(SERVICE_FILE_PATH).exists() {
        println!("There is nothing to remove :)");
        return;
    }

    println!("removing service file...");

    std::process::Command::new("systemctl")
        .args(["stop", "mouse_fix"])
        .output()
        .unwrap();

    std::process::Command::new("systemctl")
        .args(["disable", "mouse_fix"])
        .output()
        .unwrap();

    fs::remove_file(SERVICE_FILE_PATH).expect("");

    std::process::Command::new("systemctl")
        .arg("daemon-reload")
        .output()
        .unwrap();

    println!("It's done.");
}
