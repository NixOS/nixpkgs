{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  git,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-mobile2";
  version = "0.22.2";

  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = "cargo-mobile2";
    rev = "cargo-mobile2-v${finalAttrs.version}";
    hash = "sha256-pSp7w823Jjjg0PEnCc7jVLBbOgvR7JAjtD8OK5voC0A=";
  };

  # Manually specify the sourceRoot since this crate depends on other crates in the workspace. Relevant info at
  # https://discourse.nixos.org/t/difficulty-using-buildrustpackage-with-a-src-containing-multiple-cargo-workspaces/10202
  # sourceRoot = "${src.name}/tooling/cli";

  cargoHash = "sha256-aci1QF/O2J6Yix4UkxPCVW+c+xoqm7AvdhlkF7y1GqA=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [
    pkg-config
    git
    makeWrapper
  ];

  preBuild = ''
    mkdir -p $out/share/
    # during the install process tauri-mobile puts templates and commit information in CARGO_HOME
    export CARGO_HOME=$out/share/
  '';

  preFixup = ''
    for bin in $out/bin/cargo-*; do
      wrapProgram $bin \
        --set CARGO_HOME "$out/share"
    done
  '';

  meta = {
    description = "Rust on mobile made easy";
    homepage = "https://tauri.app/";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
