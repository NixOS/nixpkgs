{
  stdenv,
  lib,
  fetchFromGitHub,
  juce,
  cmake,
  pkg-config,
  libx11,
  libxrandr,
  libxinerama,
  libxext,
  libxcursor,
  libxtst,
  freetype,
  fontconfig,
  curl,
  alsa-lib,
  expat,
  nix-update-script,

  buildVST3 ? true,
  buildStandalone ? true,
}:
let
  formats = lib.concatStringsSep " " [
    (lib.optionalString buildVST3 "VST3")
    (lib.optionalString buildStandalone "Standalone")
  ];
in
stdenv.mkDerivation {
  pname = "blocks";
  version = "0-unstable-2024-08-08";

  src = fetchFromGitHub {
    owner = "dan-german";
    repo = "blocks";
    rev = "fae783735daa8cb1a0b8158508ccede4292639ae";
    hash = "sha256-TxG4Gnpen+klAJUqbq+40Xzkxk/Osl41Vmc3u1WhIGs=";
  };

  preConfigure = ''
    # JUCE submodule from upstream is too old
    rm -r JUCE
    ln -s ${juce.src} JUCE
  '';

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "FORMATS AU VST3 Standalone" "FORMATS ${formats}" \
      --replace-fail "juce::juce_recommended_lto_flags)" ") # Not forcing LTO"
  '';

  # https://github.com/dan-german/blocks/issues/39
  cmakeBuildType = "Debug";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libx11
    libxrandr
    libxinerama
    libxext
    libxcursor
    libxtst
    freetype
    fontconfig
    curl
    alsa-lib
    expat
  ];

  installPhase = ''
    runHook preInstall

    pushd blocks_artefacts/Debug
      ${lib.optionalString buildStandalone ''
        install -Dm755 Standalone/blocks -t $out/bin
      ''}

      ${lib.optionalString buildVST3 ''
        mkdir -p $out/lib/vst3
        cp -r VST3/blocks.vst3 $out/lib/vst3
      ''}
    popd

    runHook postInstall
  '';

  # Needed for standalone
  NIX_LDFLAGS = [
    "-lX11"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modular synthesizer audio plugin";
    homepage = "https://www.soonth.com";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = [ lib.maintainers.mrtnvgr ];
  }
  // lib.optionalAttrs buildStandalone {
    mainProgram = "blocks";
  };
}
