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
  fmt_8,
  nlohmann_json,
  yara,
  rsync,
  autoPatchelfHook,
}:

let
  version = "1.35.4";
  patterns_version = "1.35.4";

  patterns_src = fetchFromGitHub {
    name = "ImHex-Patterns-source-${patterns_version}";
    owner = "WerWolv";
    repo = "ImHex-Patterns";
    rev = "ImHex-v${patterns_version}";
    hash = "sha256-7ch2KXkbkdRAvo3HyErWcth3kG4bzYvp9I5GZSsb/BQ=";
  };

in
stdenv.mkDerivation rec {
  pname = "imhex";
  inherit version;

  src = fetchFromGitHub {
    name = "ImHex-source-${version}";
    fetchSubmodules = true;
    owner = "WerWolv";
    repo = "ImHex";
    rev = "refs/tags/v${version}";
    hash = "sha256-6QpmFkSMQpGlEzo7BHZn20c+q8CTDUB4yO87wMU5JT4=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    llvm
    python3
    perl
    pkg-config
    rsync
  ];

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
  ];

  # autoPatchelfHook only searches for *.so and *.so.*, and won't find *.hexpluglib
  # however, we will append to RUNPATH ourselves
  autoPatchelfIgnoreMissingDeps = [ "*.hexpluglib" ];
  appendRunpaths = [
    (lib.makeLibraryPath [ libGL ])
    "${placeholder "out"}/lib/imhex/plugins"
  ];

  cmakeFlags = [
    "-DIMHEX_OFFLINE_BUILD=ON"
    "-DUSE_SYSTEM_CAPSTONE=ON"
    "-DUSE_SYSTEM_CURL=ON"
    "-DUSE_SYSTEM_FMT=ON"
    "-DUSE_SYSTEM_LLVM=ON"
    "-DUSE_SYSTEM_NLOHMANN_JSON=ON"
    "-DUSE_SYSTEM_YARA=ON"
  ];

  # rsync is used here so we can not copy the _schema.json files
  postInstall = ''
    mkdir -p $out/share/imhex
    rsync -av --exclude="*_schema.json" ${patterns_src}/{constants,encodings,includes,magic,patterns} $out/share/imhex
  '';

  meta = with lib; {
    description = "Hex Editor for Reverse Engineers, Programmers and people who value their retinas when working at 3 AM";
    homepage = "https://github.com/WerWolv/ImHex";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [
      kashw2
      cafkafk
    ];
    platforms = platforms.linux;
  };
}
