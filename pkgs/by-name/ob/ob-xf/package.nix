{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  writableTmpDirAsHomeHook,
  alsa-lib,
  libx11,
  libxcursor,
  libxrandr,
  libxinerama,
  libxext,
  freetype,
  fontconfig,
  expat,

  buildVST3 ? true,
  buildCLAP ? true,
  buildStandalone ? true,
  buildLV2 ? stdenv.targetPlatform.isLinux,

  supplyAssets ? true,
  ...
}:
let
  inherit (lib) optional optionalString strings;

  versionDay = 16;
  date = "2025-11-${toString versionDay}";
  fakeVersion = "0.8.${toString (versionDay + 1)}";

  juceFormats = strings.join " " [
    (optionalString buildVST3 "VST3")
    (optionalString buildStandalone "Standalone")
    (optionalString buildLV2 "LV2")
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ob-xf";
  version = "0-unstable-${date}";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "OB-Xf";
    tag = "ReWork";
    hash = "sha256-RwN40PEGWcwn0IwaFYu2VFpOgRUWt2utsHO6y0nbdr4=";
    fetchSubmodules = true;
  };

  patches = [
    ./0001-juce-formats.diff
  ]
  ++ optional (!buildCLAP) ./0002-disable-clap.diff;

  postPatch = ''
    # Bypass versioning logic that relies on current date
    substituteInPlace CMakeLists.txt \
      --replace-fail '0.''${PART0}.''${PART1}' "${fakeVersion}"

    # Ignore warnings
    substituteInPlace CMakeLists.txt \
      --replace-fail "-Werror" "-Wno-error"

    substituteInPlace CMakeLists.txt \
      --replace-fail "list(APPEND OBXF_JUCE_FORMATS VST3 Standalone)" \
                     "list(APPEND OBXF_JUCE_FORMATS ${juceFormats})"

    cat > BUILD_VERSION << EOF
    SST_VERSION_INFO
    ${finalAttrs.src.rev}
    -no-tag-
    main
    Nightly-${date}
    EOF
  '';

  cmakeFlags = [
    "-DDISPLAY_VERSION=${fakeVersion}"
    "-DCOMMIT_HASH=${finalAttrs.src.rev}"
    "-DBRANCH=main"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    alsa-lib
    libx11
    libxcursor
    libxrandr
    libxinerama
    libxext
    freetype
    fontconfig
    expat
  ];

  configurePhase = ''
    runHook preConfigure
    cmake -B Builds/Release -DCMAKE_BUILD_TYPE=Release .
    runHook postConfigure
  '';

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  buildPhase = ''
    runHook preBuild
    cmake --build Builds/Release --config Release --target obxf-staged
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pushd Builds/Release/obxf_products
      ${optionalString buildStandalone ''
        mkdir -p $out/bin
        install -Dm755 OB-Xf -t $out/bin
      ''}

      ${optionalString buildCLAP ''
        mkdir -p $out/lib/clap
        install -Dm755 OB-Xf.clap -t $out/lib/clap
      ''}

      ${optionalString buildVST3 ''
        mkdir -p $out/lib/vst3
        cp -r OB-Xf.vst3 $out/lib/vst3
      ''}

      ${optionalString buildLV2 ''
        mkdir -p $out/lib/lv2
        cp -r OB-Xf.lv2 $out/lib/lv2
      ''}
    popd

    ${optionalString supplyAssets ''
      mkdir -p $out/share
      cp -r "assets/installer/Surge Synth Team" $out/share/
    ''}

    runHook postInstall
  '';

  # TODO: enable auto-updates when OB-Xf is no longer in beta state
  # passthru.updateScript = nix-update-script { };

  # Needed for standalone
  NIX_LDFLAGS = [
    "-lX11"
  ];

  meta = {
    description = "Continuation of the last open source version of OB-Xd";
    homepage = "https://github.com/surge-synthesizer/OB-Xf";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.mrtnvgr ];
  }
  // lib.optionalAttrs buildStandalone {
    mainProgram = "OB-Xf";
  };
})
