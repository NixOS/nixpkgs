{ lib
, stdenv
, rustPlatform
, fetchzip
, cargo
, pkg-config
, python3
, rustc
, alsa-lib
, libglvnd
, libjack2
, libX11
, libXcursor
, xcbutilwm
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "one-trick-keys";
  version = "1.0.0";

  src = fetchzip {
    url = "https://punklabs.com/content/projects/ot-keys/downloads/OneTrickKEYS-Source-v${finalAttrs.version}.zip";
    hash = "sha256-na6htrRksr/8pmtMCVMHW88Bokgp8npFfk53cxUxyQ8=";
    stripRoot = false;
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "assert_no_alloc-1.1.2" = "sha256-kCwtn0uONDTlDqfCpYtjB3spYM89qWjkzUOdcGjtY3c=";
      "baseview-0.1.0" = "sha256-QAkOTdA5krZPOUs7ExTVGfqK+sxG2A4H87GZgDl2LpU=";
      "clap-sys-0.3.0" = "sha256-svq9DMqzKVZCU07FiOIsdCt78BJctwlPobSlNZGeBxQ=";
      "egui-baseview-0.2.0" = "sha256-JingnLkyDq2yy+rktqGlEUg6b0VZvX1oXhnkYaKABEQ=";
      "faust-types-0.1.0" = "sha256-23S5xAu+ZBQ6c2EEUFigV6XKDUzYycGfZOJiTwWy3ag=";
      "nih_plug-0.0.0" = "sha256-nnUoloyO74Xff3KhgMuodFLJqFRidpdD3k/H195UvHw=";
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
    xcbutilwm
  ];

  buildPhase = ''
    runHook preBuild

    cargo xtask bundle onetrick_keys --release

    runHook preBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/vst3 $out/lib/clap
    cp -R "target/bundled/OneTrick KEYS" $out/bin
    cp -R "target/bundled/OneTrick KEYS.clap" $out/lib/clap
    cp -R "target/bundled/OneTrick KEYS.vst3" $out/lib/vst3

    runHook postInstall
  '';

  meta = with lib; {
    description = "A physically modeled piano synth with a chill lo-fi sound.";
    homepage = "https://punklabs.com/ot-keys";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ minijackson ];
    mainProgram = "OneTrick KEYS";
    inherit (rustc.meta) platforms;
  };
})
