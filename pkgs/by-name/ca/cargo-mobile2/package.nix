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
  version = "0.20.7";
in
rustPlatform.buildRustPackage {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = "cargo-mobile2";
    rev = "cargo-mobile2-v${version}";
    hash = "sha256-aQLFYnPY6V8+GcK0YGR11RAaqEOxlSpRjzpy7cCSSz8=";
  };

  # Manually specify the sourceRoot since this crate depends on other crates in the workspace. Relevant info at
  # https://discourse.nixos.org/t/difficulty-using-buildrustpackage-with-a-src-containing-multiple-cargo-workspaces/10202
  # sourceRoot = "${src.name}/tooling/cli";

  cargoHash = "sha256-2ecNknkFFnqllCPxiIZY5LpVugiEyIY3P6ouNiv/aZc=";

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
