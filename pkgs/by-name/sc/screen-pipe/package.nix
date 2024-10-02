{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  ffmpeg,
  oniguruma,
  openssl,
  sqlite,
  stdenv,
  darwin,
  alsa-lib,
  xorg,
}:
rustPlatform.buildRustPackage rec {
  pname = "screen-pipe";
  version = "0.1.93";

  src = fetchFromGitHub {
    owner = "mediar-ai";
    repo = "screen-pipe";
    rev = "v${version}";
    hash = "sha256-70cb41a6229a45fb150884baf9768febe41a629f3e40fb75a931150fd7341b1a=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cpal-0.15.3" = "sha256-eKn3tS5QuqbMTwnRAEybvbPZOiKiid7ghGztAmrs9fw=";
      "rusty-tesseract-1.1.10" = "sha256-XT74zGn+DetEBUujHm4Soe2iorQcIoUeZbscTv+64hw=";
    };
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      dbus
      ffmpeg
      oniguruma
      openssl
      sqlite
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk_12_3.frameworks;
      [
        CoreAudio
        AudioUnit
        CoreFoundation
        CoreGraphics
        CoreMedia
        IOKit
        Metal
        MetalPerformanceShaders
        Security
        ScreenCaptureKit
        SystemConfiguration
      ]
    )
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      xorg.libxcb
    ];

  buildFeatures = lib.optional stdenv.hostPlatform.isDarwin "metal";

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  doCheck = false; # Tests fail to build

  meta = {
    description = "Personalized AI powered by what you've seen, said, or heard";
    homepage = "https://github.com/mediar-ai/screen-pipe";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "screen-pipe";
  };
}
