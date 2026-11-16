{
  rustPlatform,
  fetchFromGitHub,
  lib,
  sqlite,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "config-store";
  version = "1.0.1";

  buildInputs = [
    sqlite
  ];

  src = fetchFromGitHub {
    owner = "DOD-101";
    repo = "config-store";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6axlKQdg0DRe6bAPRO+TOW1tAZ2lXYVKwJG68hEZZMI=";
  };

  cargoHash = "sha256-cj71M3JLxrrKCBoHuoVvpNL59ZlWh5NCDQaJnZ3xhUA=";

  meta = {
    description = "Simple key-value store designed to be used from shell scripts written in Rust";
    homepage = "https://github.com/DOD-101/config-store";
    mainProgram = "config-store";
    license = with lib.licenses; [
      mit
      asl20
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ dod-101 ];
  };
})
