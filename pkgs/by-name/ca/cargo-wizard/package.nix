{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-wizard";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "kobzol";
    repo = "cargo-wizard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WLGE2ZuytjSridZwfUTtNQF5woeBbx5ZoHfB9eyvedI=";
  };

  cargoHash = "sha256-vRakgwZRyYkk3xFfZzl197tgRmx+/g2b8eaDunwrCzM=";

  # cargo-wizard still suggests lld for aarch64-linux on Rust 1.90+, so the
  # nightly integration test must expect both rustflags there.
  postPatch = ''
    substituteInPlace tests/integration/dialog.rs \
      --replace-fail 'if rustversion::cfg!(before(1.90.0)) {' \
        'if rustversion::cfg!(before(1.90.0)) || cfg!(all(target_os = "linux", target_arch = "aarch64")) {'
  '';

  preCheck = ''
    export PATH=$PATH:$PWD/target/${stdenv.hostPlatform.rust.rustcTarget}/$cargoBuildType
  '';

  meta = {
    description = "Cargo subcommand for configuring Cargo profile for best performance";
    homepage = "https://github.com/kobzol/cargo-wizard";
    changelog = "https://github.com/kobzol/cargo-wizard/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "cargo-wizard";
  };
})
