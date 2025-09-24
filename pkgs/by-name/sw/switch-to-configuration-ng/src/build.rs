use std::io::Write;

fn code_for_dbus_xml(xml: impl AsRef<std::path::Path>) -> String {
    dbus_codegen::generate(
        &std::fs::read_to_string(xml).unwrap(),
        &dbus_codegen::GenOpts {
            methodtype: None,
            connectiontype: dbus_codegen::ConnectionType::Blocking,
            ..Default::default()
        },
    )
    .unwrap()
}

fn main() {
    let systemd_dbus_interface_dir = std::env::var("SYSTEMD_DBUS_INTERFACE_DIR").unwrap();
    let systemd_dbus_interface_dir = std::path::Path::new(systemd_dbus_interface_dir.as_str());

    let out_path = std::path::PathBuf::from(std::env::var("OUT_DIR").unwrap());

    let systemd_manager_code =
        code_for_dbus_xml(systemd_dbus_interface_dir.join("org.freedesktop.systemd1.Manager.xml"));
    let mut file = std::fs::File::create(out_path.join("systemd_manager.rs")).unwrap();
    file.write_all(systemd_manager_code.as_bytes()).unwrap();

    let logind_manager_code =
        code_for_dbus_xml(systemd_dbus_interface_dir.join("org.freedesktop.login1.Manager.xml"));
    let mut file = std::fs::File::create(out_path.join("logind_manager.rs")).unwrap();
    file.write_all(logind_manager_code.as_bytes()).unwrap();
}
