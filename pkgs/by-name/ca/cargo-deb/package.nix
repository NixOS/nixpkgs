{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  dpkg,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-deb";
  version = "3.6.3";

  src = fetchFromGitHub {
    owner = "kornelski";
    repo = "cargo-deb";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qYLJNhxBfSopfaNEh9FnKoKdq1Uu8nfWPOhpqzQH288=";
  };

  cargoHash = "sha256-VC116dm4XeR8ofvP3H0R5LiZOMqlUPpVGzZvTc9DhDk=";

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

  meta = {
    description = "Cargo subcommand that generates Debian packages from information in Cargo.toml";
    mainProgram = "cargo-deb";
    homepage = "https://github.com/kornelski/cargo-deb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
