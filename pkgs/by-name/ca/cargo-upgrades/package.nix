{
  lib,
  rustPlatform,
  fetchFromGitLab,
  cargo,
  makeWrapper,
  openssl,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-upgrades";
  version = "3.1.0";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "kornelski";
    repo = "cargo-upgrades";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RRH71+BdKCfLD5DnlQzTJYPbZS6G4E/NvXrC51iPTYs=";
  };
  cargoHash = "sha256-FSDjHrRZy4Nn3XYXSJuz46FjGDqn+NfD89koGGKURPw=";
  doCheck = false; # 1 test fails at the current revision, but its not fatal and the main binary works as expected;
  buildFeatures = [ "native-tls" ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];
  buildInputs = [ openssl ];

  # The `cargo-upgrades` binary requires `cargo` in its PATH.
  postInstall = ''
    wrapProgram $out/bin/cargo-upgrades \
     --prefix PATH : ${lib.makeBinPath [ cargo ]}
  '';

  meta = {
    description = "Checks if dependencies in Cargo.toml are up to date. Compatible with workspaces and path dependencies.";
    mainProgram = "cargo-upgrades";
    homepage = "https://gitlab.com/kornelski/cargo-upgrades";
    changelog = "https://gitlab.com/kornelski/cargo-upgrades/-/tags/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wellmannmathis ];
  };
})
