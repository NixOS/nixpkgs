{
  lib,
  stdenv,
  cmake,
  llvm,
  fetchFromGitHub,
  mbedtls,
  gtk3,
  pkg-config,
  capstone,
  dbus,
  libGLU,
  libGL,
  glfw3,
  file,
  perl,
  python3,
  jansson,
  curl,
  fmt,
  nlohmann_json,
  yara,
  rsync,
  nix-update-script,
  autoPatchelfHook,
  makeWrapper,
}:

let
  version = "1.37.4";
  patterns_version = "1.37.4";

  patterns_src = fetchFromGitHub {
    name = "ImHex-Patterns-source-${patterns_version}";
    owner = "WerWolv";
    repo = "ImHex-Patterns";
    tag = "ImHex-v${patterns_version}";
    hash = "sha256-2NgMYaG6+XKp0fIHAn3vAcoXXa3EF4HV01nI+t1IL1U=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "imhex";
  inherit version;

  src = fetchFromGitHub {
    name = "ImHex-source-${version}";
    fetchSubmodules = true;
    owner = "WerWolv";
    repo = "ImHex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uenwAaIjtBzrtiLdy6fh5TxtbWtUJbtybNOLP3+8blA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    llvm
    python3
    perl
    pkg-config
    rsync
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [
    capstone
    curl
    dbus
    file
    fmt
    glfw3
    gtk3
    jansson
    libGLU
    mbedtls
    nlohmann_json
    yara
  ];

  # autoPatchelfHook only searches for *.so and *.so.*, and won't find *.hexpluglib
  # however, we will append to RUNPATH ourselves
  autoPatchelfIgnoreMissingDeps = lib.optionals stdenv.hostPlatform.isLinux [ "*.hexpluglib" ];
  appendRunpaths = lib.optionals stdenv.hostPlatform.isLinux [
    (lib.makeLibraryPath [ libGL ])
    "${placeholder "out"}/lib/imhex/plugins"
  ];

  cmakeFlags = [
    (lib.cmakeBool "IMHEX_OFFLINE_BUILD" true)
    (lib.cmakeBool "IMHEX_COMPRESS_DEBUG_INFO" false) # avoids error: cannot compress debug sections (zstd not enabled)
    (lib.cmakeBool "IMHEX_GENERATE_PACKAGE" stdenv.hostPlatform.isDarwin)
    (lib.cmakeBool "USE_SYSTEM_CAPSTONE" true)
    (lib.cmakeBool "USE_SYSTEM_CURL" true)
    (lib.cmakeBool "USE_SYSTEM_FMT" true)
    (lib.cmakeBool "USE_SYSTEM_LLVM" true)
    (lib.cmakeBool "USE_SYSTEM_NLOHMANN_JSON" true)
    (lib.cmakeBool "USE_SYSTEM_YARA" true)
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  # Comment out fixup_bundle in PostprocessBundle.cmake as we are not building a standalone application
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace cmake/modules/PostprocessBundle.cmake \
      --replace-fail "fixup_bundle" "#fixup_bundle"
  '';

  # rsync is used here so we can not copy the _schema.json files
  postInstall =
    if stdenv.hostPlatform.isLinux then
      ''
        mkdir -p $out/share/imhex
        rsync -av --exclude="*_schema.json" ${patterns_src}/{constants,encodings,includes,magic,nodes,patterns} $out/share/imhex
        # without this imhex is not able to find pattern files
        wrapProgram $out/bin/imhex --prefix XDG_DATA_DIRS : $out/share
      ''
    else if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/Applications
        mv $out/imhex.app $out/Applications
        rsync -av --exclude="*_schema.json" ${patterns_src}/{constants,encodings,includes,magic,nodes,patterns} "$out/Applications/imhex.app/Contents/MacOS"
        install_name_tool \
          -change "$out/lib/libimhex.${finalAttrs.version}${stdenv.hostPlatform.extensions.sharedLibrary}" \
          "@executable_path/../Frameworks/libimhex.${finalAttrs.version}${stdenv.hostPlatform.extensions.sharedLibrary}" \
          "$out/Applications/imhex.app/Contents/MacOS/imhex"
        makeWrapper "$out/Applications/imhex.app/Contents/MacOS/imhex" "$out/bin/imhex"
      ''
    else
      throw "Unsupported system";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hex Editor for Reverse Engineers, Programmers and people who value their retinas when working at 3 AM";
    homepage = "https://github.com/WerWolv/ImHex";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [
      kashw2
      cafkafk
      govanify
      ryand56
    ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
