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
  version = "0.22.3";

  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = "cargo-mobile2";
    rev = "cargo-mobile2-v${finalAttrs.version}";
    hash = "sha256-rPLGh7/lGsmoidtr+UNrxzUgqtiHvkqZs2/la4L6zQM=";
  };

  # Manually specify the sourceRoot since this crate depends on other crates in the workspace. Relevant info at
  # https://discourse.nixos.org/t/difficulty-using-buildrustpackage-with-a-src-containing-multiple-cargo-workspaces/10202
  # sourceRoot = "${src.name}/tooling/cli";

  cargoHash = "sha256-ht9ofFa4H/Ux6a31vMNdKNhrX48yoYM1qAPoxCjude0=";

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
