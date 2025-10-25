{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  freetype,
  fontconfig,
  curl,
  webkitgtk_4_1,
  glib,
  libsysprof-capture,
  pcre2,
  util-linux,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  libxdmcp,
  libdeflate,
  lerc,
  xz,
  libwebp,
  libxkbcommon,
  libepoxy,
  xorg,
  sqlite,

  compileVST3 ? true,
  compileClap ? true,
  compileStandalone ? true,
  compileLV2 ? stdenv.targetPlatform.isLinux,

  supplyAssets ? true,
  ...
}:
let
  inherit (lib) optional optionalString strings;

  versionDay = 19;
  date = "2025-10-${toString versionDay}";
  fakeVersion = "0.8.${toString (versionDay + 1)}";

  juceFormats = strings.join " " [
    (optionalString compileVST3 "VST3")
    (optionalString compileStandalone "Standalone")
    (optionalString compileLV2 "LV2")
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "OB-Xf";
  version = "0-unstable-${date}";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "OB-Xf";
    rev = "c0783cc3054b3032684c9f515144811f22fb0f07";
    hash = "sha256-ZgANtSZkvrqzk6R6pBM0QadYt+AfZTi7HStfpkItiu4=";
    fetchSubmodules = true;
  };

  patches = [
    ./0001-juce-formats.diff
  ]
  ++ optional (!compileClap) ./0002-disable-clap.diff;

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
  ];

  buildInputs = [
    alsa-lib
    freetype
    fontconfig
    curl
    webkitgtk_4_1
    glib
    libsysprof-capture
    pcre2
    util-linux
    libselinux
    libsepol
    libthai
    libdatrie
    libxdmcp
    libdeflate
    lerc
    xz
    libwebp
    libxkbcommon
    libepoxy
    xorg.libXtst
    sqlite
  ];

  configurePhase = ''
    runHook preConfigure
    cmake -B Builds/Release -DCMAKE_BUILD_TYPE=Release .
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    cmake --build Builds/Release --config Release --target obxf-staged
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pushd Builds/Release/obxf_products
      ${optionalString compileStandalone ''
        mkdir -p $out/bin
        mv OB-Xf $out/bin/OB-Xf
      ''}

      ${optionalString compileClap ''
        mkdir -p $out/lib/clap
        mv OB-Xf.clap $out/lib/clap/
      ''}

      ${optionalString compileVST3 ''
        mkdir -p $out/lib/vst3
        mv OB-Xf.vst3 $out/lib/vst3/
      ''}

      ${optionalString compileLV2 ''
        mkdir -p $out/lib/lv2
        mv OB-Xf.lv2 $out/lib/lv2/
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

  meta = {
    description = "A continuation of the last open source version of OB-Xd";
    homepage = "https://github.com/surge-synthesizer/OB-Xf";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.mrtnvgr ];
    mainProgram = optionalString compileStandalone "OB-Xf";
  };
})
