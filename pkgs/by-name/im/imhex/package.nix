{
  lib,
  stdenv,
  cmake,
  darwin,
  llvmPackages_17,
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
  fmt_8,
  nlohmann_json,
  yara,
  rsync,
  nix-update-script,
  autoPatchelfHook,
  makeWrapper,
  overrideSDK,
}:

let
  version = "1.35.3";
  patterns_version = "1.35.3";

  llvmPackages = llvmPackages_17;

  stdenv' =
    let
      baseStdenv = if stdenv.cc.isClang then llvmPackages.stdenv else stdenv;
    in
    if stdenv.isDarwin then overrideSDK baseStdenv "11.0" else baseStdenv;

  patterns_src = fetchFromGitHub {
    name = "ImHex-Patterns-source-${patterns_version}";
    owner = "WerWolv";
    repo = "ImHex-Patterns";
    rev = "ImHex-v${patterns_version}";
    hash = "sha256-h86qoFMSP9ehsXJXOccUK9Mfqe+DVObfSRT4TCtK0rY=";
  };

in
stdenv'.mkDerivation (finalAttrs: {
  pname = "imhex";
  inherit version;

  src = fetchFromGitHub {
    name = "ImHex-source-${version}";
    fetchSubmodules = true;
    owner = "WerWolv";
    repo = "ImHex";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-8vhOOHfg4D9B9yYgnGZBpcjAjuL4M4oHHax9ad5PJtA=";
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace cmake/modules/PostprocessBundle.cmake \
      --replace-fail "fixup_bundle" "#fixup_bundle"
    substituteInPlace plugins/builtin/source/content/providers/process_memory_provider.cpp \
      --replace-fail "mach/arm/kern_return.h" "mach/machine/kern_return.h" \
      --replace-fail "mach/arm/vm_types.h" "mach/machine/vm_types.h"
  '';

  nativeBuildInputs =
    [
      cmake
      llvmPackages.llvm
      python3
      perl
      pkg-config
      rsync
    ]
    ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ]
    ++ lib.optionals stdenv.isDarwin [ makeWrapper ];

  buildInputs = [
    capstone
    curl
    dbus
    file
    fmt_8
    glfw3
    gtk3
    jansson
    libGLU
    mbedtls
    nlohmann_json
    yara
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk_11_0.frameworks.UniformTypeIdentifiers ];

  # autoPatchelfHook only searches for *.so and *.so.*, and won't find *.hexpluglib
  # however, we will append to RUNPATH ourselves
  autoPatchelfIgnoreMissingDeps = lib.optionals stdenv.isLinux [ "*.hexpluglib" ];
  appendRunpaths = lib.optionals stdenv.isLinux [
    (lib.makeLibraryPath [ libGL ])
    "${placeholder "out"}/lib/imhex/plugins"
  ];

  cmakeFlags = [
    (lib.cmakeBool "IMHEX_OFFLINE_BUILD" true)
    (lib.cmakeBool "IMHEX_COMPRESS_DEBUG_INFO" false) # avoids error: cannot compress debug sections (zstd not enabled)
    (lib.cmakeBool "IMHEX_GENERATE_PACKAGE" stdenv.isDarwin)
    (lib.cmakeBool "USE_SYSTEM_CAPSTONE" true)
    (lib.cmakeBool "USE_SYSTEM_CURL" true)
    (lib.cmakeBool "USE_SYSTEM_FMT" true)
    (lib.cmakeBool "USE_SYSTEM_LLVM" true)
    (lib.cmakeBool "USE_SYSTEM_NLOHMANN_JSON" true)
    (lib.cmakeBool "USE_SYSTEM_YARA" true)
  ];

  # rsync is used here so we can not copy the _schema.json files
  postInstall =
    if stdenv.isLinux then
      ''
        mkdir -p $out/share/imhex
        rsync -av --exclude="*_schema.json" ${patterns_src}/{constants,encodings,includes,magic,nodes,patterns} $out/share/imhex
      ''
    else if stdenv.isDarwin then
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

  meta = with lib; {
    description = "Hex Editor for Reverse Engineers, Programmers and people who value their retinas when working at 3 AM";
    homepage = "https://github.com/WerWolv/ImHex";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [
      kashw2
      cafkafk
    ];
    platforms = platforms.unix;
  };
})
