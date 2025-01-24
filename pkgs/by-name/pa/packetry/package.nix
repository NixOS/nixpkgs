{
  fetchFromGitHub,
  lib,
  stdenv,
  rustPlatform,
  gtk4,
  pkg-config,
  pango,
  wrapGAppsHook4,
  apple-sdk_11,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "packetry";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "packetry";
    rev = "refs/tags/v${version}";
    hash = "sha256-eDVom0kAL1QwO8BtrJS76VTvxtKs7CP6Ob5BWlE6wOM=";
  };

  cargoHash = "sha256-xz9PdVVB1u6s/anPBRonWS1kMN+4kfkK/gaOlF9Z3yk=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs =
    [
      gtk4
      pango
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
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
