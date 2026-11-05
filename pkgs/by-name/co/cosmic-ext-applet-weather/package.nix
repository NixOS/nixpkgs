{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  just,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-weather";
  version = "0-unstable-2026-10-07";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ext-applet-weather";
    rev = "9c295eec5850e39f5c652db7a1e412eb723750c3";
    hash = "sha256-27EAI2G6ekl8jG/iQShSqm97d2EbobWEB6A/jp83DAs=";
  };

  cargoHash = "sha256-QbEnqAY9fiIkdTCurXTegnXCt+n9O+3Rix8XjHKRxTQ=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  postInstall = ''
    install -Dm644 data/io.github.cosmic_utils.weather-applet.metainfo.xml -t $out/share/metainfo
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Simple weather info applet for COSMIC";
    homepage = "https://github.com/cosmic-utils/cosmic-ext-applet-weather";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-ext-applet-weather";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.linux;
  };
}
