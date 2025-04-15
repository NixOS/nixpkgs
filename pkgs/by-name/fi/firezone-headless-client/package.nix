{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "firezone-headless-client";
  version = "1.4.5";
  src = fetchFromGitHub {
    owner = "firezone";
    repo = "firezone";
    tag = "headless-client-${version}";
    hash = "sha256-IVbMdRtb6cu4obTFYPAYQXu9sXH7vT7K9j79IXg0KXk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8//Gg45iJw9rfEn08FW+wDbg7Dz2MyKFGf3p2Td7kHA=";
  sourceRoot = "${src.name}/rust";
  buildAndTestSubdir = "headless-client";
  RUSTFLAGS = "--cfg system_certs";

  # Required to remove profiling arguments which conflict with this builder
  postPatch = ''
    rm .cargo/config.toml
  '';

  # Required to run tests
  preCheck = ''
    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "headless-client-(.*)"
    ];
  };

  meta = {
    description = "CLI client for the Firezone zero-trust access platform";
    homepage = "https://github.com/firezone/firezone";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      oddlama
      patrickdag
    ];
    mainProgram = "firezone-headless-client";
  };
}
