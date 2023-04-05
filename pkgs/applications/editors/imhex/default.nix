{ lib
, gcc12Stdenv
, cmake
, llvm
, fetchFromGitHub
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
}:

let
  # when bumping the version, check if imhex has gotten support for the capstone version in nixpkgs
  version = "1.27.1";

  patterns_src = fetchFromGitHub {
    owner = "WerWolv";
    repo = "ImHex-Patterns";
    rev = "ImHex-v${version}";
    hash = "sha256-7Aaj+W+zXjHO8A2gmWtp5Pa/i5Uk8lXzX2WHjPIPRZI=";
  };

in
gcc12Stdenv.mkDerivation rec {
  pname = "imhex";
  inherit version;

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "WerWolv";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-meOx8SkufXbXuBIVefr/mO9fsUi3zeQmqmf86+aDMaI=";
  };

  nativeBuildInputs = [ cmake llvm python3 perl pkg-config ];

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
    # see comment at the top about our version of capstone
    "-DUSE_SYSTEM_CAPSTONE=OFF"
    "-DUSE_SYSTEM_CURL=ON"
    "-DUSE_SYSTEM_FMT=ON"
    "-DUSE_SYSTEM_LLVM=ON"
    "-DUSE_SYSTEM_NLOHMANN_JSON=ON"
    "-DUSE_SYSTEM_YARA=ON"
  ];

  postInstall = ''
    mkdir -p $out/share/imhex
    for d in ${patterns_src}/{constants,encodings,includes,magic,patterns}; do
      cp -r $d $out/share/imhex/
    done
  '';

  meta = with lib; {
    description = "Hex Editor for Reverse Engineers, Programmers and people who value their retinas when working at 3 AM";
    homepage = "https://github.com/WerWolv/ImHex";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ luis ];
    platforms = platforms.linux;
  };
}
