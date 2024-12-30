{
  rustPlatform,
  lib,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "robrix";
  version = "0.1.0-unstable-2024-12-30";

  src = fetchFromGitHub {
    owner = "project-robius";
    repo = "robrix";
    rev = "5645e2804ad65cf9997c79eec4e24d0251070c6d";
    hash = "sha256-5RMVnpG5eOC1SXyzJwJWZJcLd9CylFS6i/HhbT3KwZQ=";
  };

  cargoHash = "sha256-/qKsloCpH3EYYq+HCxa7VKRx3uV/YQMc17Z/bSK3jhk=";
  useFetchCargoVendor = true;

  meta = {
    homepage = "https://github.com/project-robius/robrix";
    changelog = "https://github.com/project-robius/robrix/releases/tag/v${version}";
    description = "Robrix: a multi-platform Matrix chat client written in Rust using the Makepad UI toolkit and the Robius app dev framework";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
