{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  cmake,
  pkg-config,
  alsa-lib,
  freetype,
  fontconfig,
  libjack2,
  libGL,
  libx11,
  libxcursor,
  libxext,
  libxinerama,
  libxrandr,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ob-xf";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "OB-Xf";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-MeknY3jiUTcnX29AtdYNci4dAF1uFCZRpwrxEH3YEEM=";
  };

  postPatch = ''
    # The build calls git at configure time to determine version info.
    # Provide a static BUILD_VERSION file so git is not required.
    cat > BUILD_VERSION <<EOF
    SST_VERSION_INFO
    5044e2e3
    v${finalAttrs.version}
    main
    ${finalAttrs.version}
    EOF
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    alsa-lib
    freetype
    fontconfig
    libjack2
    libGL
    libx11
    libxcursor
    libxext
    libxinerama
    libxrandr
  ];

  enableParallelBuilding = true;

  # JUCE dlopen's x11 at runtime, crashes without it
  env.NIX_LDFLAGS = "-lX11";

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  installPhase = ''
    runHook preInstall

    # Factory data (patches, themes) — provided by upstream's install() rule
    cmake --install .

    mkdir -p $out/lib/{vst3,lv2,clap}

    cp -r OB-Xf_artefacts/Release/VST3/OB-Xf.vst3 $out/lib/vst3/
    cp -r OB-Xf_artefacts/Release/LV2/OB-Xf.lv2 $out/lib/lv2/
    cp -r OB-Xf_artefacts/Release/CLAP/OB-Xf.clap $out/lib/clap/

    install -Dm755 OB-Xf_artefacts/Release/Standalone/OB-Xf $out/bin/OB-Xf

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Virtual analog synthesizer plug-in inspired by the Oberheim OB-X";
    homepage = "https://surge-synth-team.org/ob-xf/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ magnetophon ];
    mainProgram = "OB-Xf";
  };
})
