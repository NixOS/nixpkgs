use nixos_generate_config::run_app;

#[test]
fn it_shows_help() {
    let args = vec![
        String::from("nixos-generate-config"),
        String::from("--help"),
    ];

    // make man quit immediately
    std::env::set_var("MANPAGER", "true");

    let res = run_app(&args);
    assert_eq!(res, 0);
}
