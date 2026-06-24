{
  rustPlatform,
  nix-update-script,
  lib,
  fetchFromGitHub,
}:
let
  pname = "numa";
  version = "0.20.0";
  gitHash = "sha256-RCb3k8uDnF3bUXAoKbEM6xBC7S9sKyDRy+bjhodqPeg=";
  cargoHash = "sha256-svTcUocOSHNmXcPQaBusOSh3oVb2kRbPS9Hy4XdVpv4=";

  src = fetchFromGitHub {
    owner = "razvandimescu";
    repo = pname;
    tag = "v${version}";
    hash = gitHash;
  };
in
rustPlatform.buildRustPackage {
  inherit
    pname
    src
    version
    cargoHash
    ;

  __structuredAttrs = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Portable DNS resolver in Rust";
    homepage = "https://numa.rs";
    changelog = "https://github.com/razvandimescu/numa/releases/tag/v${version}";
    license = with lib.licenses; mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bubylou ];
    mainProgram = "numa";
  };
}
