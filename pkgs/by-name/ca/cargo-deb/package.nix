{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  dpkg,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deb";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "kornelski";
    repo = "cargo-deb";
    rev = "v${version}";
    hash = "sha256-lTxMaYb7+cLQB+L8OJ8Q6HwD37Bw3kzRVLtovAJxpe0=";
  };

  cargoHash = "sha256-QidnhKXGcR4I+FULRrt+jTQNp+DE9SVW8wlH5Ypknqg=";

  nativeBuildInputs = [
    makeWrapper
  ];

  checkFlags = [
    # This is an FHS specific assert depending on glibc location
    "--skip=dependencies::resolve_test"
    "--skip=run_cargo_deb_command_on_example_dir_with_separate_debug_symbols"
    # The following tests require empty CARGO_BUILD_TARGET env variable, but we
    # set it ever since https://github.com/NixOS/nixpkgs/pull/298108.
    "--skip=build_with_command_line_compress_gz"
    "--skip=build_with_command_line_compress_xz"
    "--skip=build_with_explicit_compress_type_gz"
    "--skip=build_with_explicit_compress_type_xz"
    "--skip=build_workspaces"
    "--skip=cwd_dir1"
    "--skip=cwd_dir2"
    "--skip=cwd_dir3"
    "--skip=run_cargo_deb_command_on_example_dir"
    "--skip=run_cargo_deb_command_on_example_dir_with_variant"
    "--skip=run_cargo_deb_command_on_example_dir_with_version"
  ];

  postInstall = ''
    wrapProgram $out/bin/cargo-deb \
      --prefix PATH : ${lib.makeBinPath [ dpkg ]}
  '';

  meta = with lib; {
    description = "Cargo subcommand that generates Debian packages from information in Cargo.toml";
    mainProgram = "cargo-deb";
    homepage = "https://github.com/kornelski/cargo-deb";
    license = licenses.mit;
    maintainers = with maintainers; [
      Br1ght0ne
      matthiasbeyer
    ];
  };
}
