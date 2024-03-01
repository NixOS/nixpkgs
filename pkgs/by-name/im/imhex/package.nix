{ lib
, stdenv
, cmake
, llvm
, fetchFromGitHub
, fetchpatch
, mbedtls
, gtk3
, pkg-config
, capstone
, dbus
, libGLU
, glfw3
, file
, perl
, python3
, jansson
, curl
, fmt_8
, nlohmann_json
, yara
, rsync
}:

let
  version = "1.32.2";
  patterns_version = "1.32.2";

  patterns_src = fetchFromGitHub {
    owner = "WerWolv";
    repo = "ImHex-Patterns";
    rev = "ImHex-v${patterns_version}";
    hash = "sha256-K+LiQvykCrOwhEVy37lh7VSf5YJyBQtLz8AGFsuRznQ=";
  };

in
stdenv.mkDerivation rec {
  pname = "imhex";
  inherit version;

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "WerWolv";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MYOZHQMYbbP01z0FyoCgTzwY1/71eUCmJYYfYvN9+so=";
  };

  patches = [
    # Backport fixes (and fix to fix) for default plugin not being loaded.
    (fetchpatch {
      url = "https://github.com/WerWolv/PatternLanguage/compare/ImHex-v1.32.2..1adcdd358d3772681242267ddd3459c9d0913796.patch";
      stripLen = 1;
      extraPrefix = "lib/external/pattern_language/";
      hash = "sha256-aGvt7vQ6PtFE3sw4rAXUP7Pq8cL29LEKyC0rJKkxOZI=";
    })
  ];

  nativeBuildInputs = [ cmake llvm python3 perl pkg-config rsync ];

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
    maintainers = with maintainers; [ luis kashw2 cafkafk ];
    platforms = platforms.linux;
  };
}
