{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  git,
  makeWrapper,
}:

let
  pname = "cargo-mobile2";
  version = "0.21.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = "cargo-mobile2";
    rev = "cargo-mobile2-v${version}";
    hash = "sha256-w95UAtAP11jaW4EqprGv+duBf81rLv8y7+Ej5SFeRAs=";
  };

  # Manually specify the sourceRoot since this crate depends on other crates in the workspace. Relevant info at
  # https://discourse.nixos.org/t/difficulty-using-buildrustpackage-with-a-src-containing-multiple-cargo-workspaces/10202
  # sourceRoot = "${src.name}/tooling/cli";

  cargoHash = "sha256-Aa4Iubl8l+tss0ClF93RqVUsB4Jg4/MQCeKSr/iY5tA=";

  preBuild = ''
    mkdir -p $out/share/
    # during the install process tauri-mobile puts templates and commit information in CARGO_HOME
    export CARGO_HOME=$out/share/
  '';

  buildInputs = [ openssl ];
  nativeBuildInputs = [
    pkg-config
    git
    makeWrapper
  ];

  preFixup = ''
    for bin in $out/bin/cargo-*; do
      wrapProgram $bin \
        --set CARGO_HOME "$out/share"
    done
  '';

  meta = with lib; {
    description = "Rust on mobile made easy";
    homepage = "https://tauri.app/";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ happysalada ];
  };
}
