{
  rustPlatform,
  lib,
  fetchFromGitHub,
  npmHooks,
  fetchNpmDeps,
  wrapGAppsHook3,
  cargo-tauri,
  nodejs,
  pkg-config,
  gtk3,
  openssl,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage rec {
  pname = "mitre-attack-navigator";
  version = "0-unstable-2025-08-25";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "mitre-attack-navigator";
    rev = "efb4c43ef4ce61d9a854974064ce137bbeef224e";
    hash = "sha256-ZsERmodvTqA0Eh1rH+rPBRpYzb/T1ujpfPWys66PbRo=";
    fetchSubmodules = true;
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-k0xjXPQsgalIXtuNCFxMWL/qCvhSRp7i6db00Gwlq1Y=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  cargoHash = "sha256-/UnM7xyH5SUDLSPE1m3R0MAl47yWOa37YiSlL3AwZAg=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    wrapGAppsHook3
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ];

  buildInputs = [
    gtk3
    openssl
    webkitgtk_4_1
  ];

  postInstall = ''
    rm -f $out/share/applications/*.desktop
    install -Dm644 attack-navigator.desktop -t $out/share/applications
  '';

  meta = {
    homepage = "https://github.com/Athena-OS/mitre-attack-navigator";
    description = "A Tauri-based desktop app for MITRE's ATT&CK Navigator cybersecurity framework";
    maintainers = with lib.maintainers; [ d3vil0p3r ];
    mainProgram = "attack-navigator";
    license = lib.licenses.gpl3Plus;
  };
}
