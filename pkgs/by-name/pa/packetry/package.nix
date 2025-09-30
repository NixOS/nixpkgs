{
  fetchFromGitHub,
  lib,
  rustPlatform,
  gtk4,
  pkg-config,
  pango,
  wrapGAppsHook4,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "packetry";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "packetry";
    tag = "v${version}";
    hash = "sha256-eDVom0kAL1QwO8BtrJS76VTvxtKs7CP6Ob5BWlE6wOM=";
  };

  cargoHash = "sha256-he+Y2vBCw5lmYe5x6myIxMKRIohBCLDQ/B1EV+4pKGs=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    pango
  ];

  # Disable test_replay tests as they need a gui
  preCheck = ''
    sed -i 's:#\[test\]:#[test] #[ignore]:' src/test_replay.rs
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  # packetry-cli is only necessary on windows https://github.com/greatscottgadgets/packetry/pull/154
  postInstall = ''
    rm $out/bin/packetry-cli
  '';

  meta = {
    description = "USB 2.0 protocol analysis application for use with Cynthion";
    homepage = "https://github.com/greatscottgadgets/packetry";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ carlossless ];
    mainProgram = "packetry";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
