{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  writableTmpDirAsHomeHook,
  alsa-lib,
  expat,
  fontconfig,
  freetype,
  libX11,
  libXcursor,
  libXext,
  libXinerama,
  libXrandr,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ripplerx";
  version = "1.5.18";

  src = fetchFromGitHub {
    owner = "tiagolr";
    repo = "ripplerx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lHLAJ8eCmn/WFYxGl/zIq8a2xPKqzpB7tilffJcXhM4=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    writableTmpDirAsHomeHook # fontconfig cache + $HOME/.{lv2,vst3}
  ];

  buildInputs = [
    alsa-lib
    expat
    fontconfig
    freetype
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
  ];

  cmakeFlags = [
    (lib.cmakeFeature "BUILD_STANDALONE" "OFF") # doesn't start
  ];

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  # LTO needs special setup on Linux
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'juce::juce_recommended_lto_flags' '# Not forcing LTO'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/{lv2,vst3}

    pushd RipplerX_artefacts/Release
    cp -r "LV2/RipplerX.lv2" $out/lib/lv2
    cp -r "VST3/RipplerX.vst3" $out/lib/vst3
    popd

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Physically modeled synth";
    longDescription = ''
      RipplerX is a physically modeled synth, capable of sounds similar to AAS Chromaphone and Ableton Collision.
    '';
    homepage = "https://github.com/tiagolr/ripplerx";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ eljamm ];
    platforms = lib.platforms.linux;
  };
})
