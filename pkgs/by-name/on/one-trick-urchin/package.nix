{
  lib,
  stdenv,
  rustPlatform,
  fetchzip,
  cargo,
  pkg-config,
  python3,
  rustc,
  alsa-lib,
  libglvnd,
  libjack2,
  libX11,
  libXcursor,
  libxcb,
  xcbutilwm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "one-trick-urchin";
  version = "1.0.0";

  src = fetchzip {
    url = "https://punklabs.com/content/projects/ot-urchin/downloads/OneTrickURCHIN-Source-v${finalAttrs.version}.zip";
    hash = "sha256-XtUcWgiHtacfbmPBFikb9Y0aErgD8jcUDggyjIgLlL4=";
    stripRoot = false;
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "assert_no_alloc-1.1.2" = "sha256-kCwtn0uONDTlDqfCpYtjB3spYM89qWjkzUOdcGjtY3c=";
      "baseview-0.1.0" = "sha256-CK0+I2NqrDRJdhg4xotleVSp0GTiY8YZK1zBDx80BUs=";
      "clap-sys-0.3.0" = "sha256-svq9DMqzKVZCU07FiOIsdCt78BJctwlPobSlNZGeBxQ=";
      "egui-baseview-0.1.0" = "sha256-ejGsP7lbjCMYDZXbJ1SH934EhfqPQQ9s6dnUVQkGfLc=";
      "faust-types-0.1.0" = "sha256-23S5xAu+ZBQ6c2EEUFigV6XKDUzYycGfZOJiTwWy3ag=";
      "nih_plug-0.0.0" = "sha256-al6D9HmyR8WFjMEyZ9rNCZXzRU3SX/uFDnr7oKJriDQ=";
      "reflink-0.1.3" = "sha256-1o5d/mepjbDLuoZ2/49Bi6sFgVX4WdCuhGJkk8ulhcI=";
      "vst3-com-0.1.0" = "sha256-tKWEmJR9aRpfsiuVr0K8XXYafVs+CzqCcP+Ea9qvZ7Y=";
    };
  };

  nativeBuildInputs = [
    cargo
    pkg-config
    python3
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    alsa-lib
    libglvnd
    libjack2
    libX11
    libXcursor
    libxcb
    xcbutilwm
  ];

  buildPhase = ''
    runHook preBuild

    cargo xtask bundle onetrick_urchin --release

    runHook preBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/vst3 $out/lib/clap
    cp -R "target/bundled/OneTrick URCHIN" $out/bin
    cp -R "target/bundled/OneTrick URCHIN.clap" $out/lib/clap
    cp -R "target/bundled/OneTrick URCHIN.vst3" $out/lib/vst3

    runHook postInstall
  '';

  meta = with lib; {
    description = "A hybrid drum synth modeling gritty lofi beats without sampling.";
    homepage = "https://punklabs.com/ot-urchin";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ minijackson ];
    mainProgram = "OneTrick URCHIN";
    inherit (rustc.meta) platforms;
  };
})
