{
  lib,
  stdenv,
  fetchFromGitHub,

  alsa-lib,
  xorg,
  libGL,
  freetype,
  ninja,
  python3,
  pkg-config,
  jack1,
}:

stdenv.mkDerivation {
  pname = "quasar";
  version = "0-unstable-2024-12-23";

  src = fetchFromGitHub {
    owner = "DarkRTA";
    repo = "quasar";
    rev = "11e24bb569ef914e1a9641323a2b9edd5b0b3e95";
    hash = "sha256-nNGaNFUIZp+rP6K6fbg+HnWpev5M44K47MGapTAyvPE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    ninja
    python3
    pkg-config
  ];

  buildInputs = [
    freetype
    alsa-lib
    libGL
    xorg.libX11
    xorg.libXinerama
    xorg.libXext
    xorg.libXcursor
    jack1
  ];

  configurePhase = ''
    runHook preConfigure

    for f in lv2 vst2 vst3 standalone; do
      python build-scripts/configure.py $f
      mv build.ninja $f.ninja
    done

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    for f in lv2 vst2 vst3 standalone; do
      ninja -f $f.ninja
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pushd out
      install -Dm755 Quasar $out/bin/Quasar
      install -Dm644 Quasar.vst2.so $out/lib/vst/Quasar.so

      mkdir -p $out/lib/lv2
      cp -r Quasar.lv2 $out/lib/lv2/Quasar.lv2

      mkdir -p $out/lib/vst3
      cp -r Quasar.vst3 $out/lib/vst3/Quasar.vst3
    popd

    runHook postInstall
  '';

  meta = {
    description = "Linux-focused fork of Matt Tytel's Vital, a spectral warping wavetable synthesizer";
    homepage = "https://github.com/DarkRTA/quasar";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mrtnvgr ];
    mainProgram = "Quasar";
  };
}
