{
  lib,
  stdenv,
  fetchpatch,
  c-ares,
  cmake,
  cryptopp,
  curl,
  fetchFromGitHub,
  ffmpeg,
  hicolor-icon-theme,
  icu,
  libmediainfo,
  libsodium,
  libtool,
  libuv,
  libxcb,
  libzen,
  mkDerivation,
  openssl,
  pkg-config,
  qtbase,
  qtdeclarative,
  qtgraphicaleffects,
  qttools,
  qtquickcontrols,
  qtquickcontrols2,
  qtsvg,
  qtx11extras,
  readline,
  sqlite,
  unzip,
  wget,
  zlib,
  qt5,
}:
mkDerivation rec {
  pname = "megasync";
  version = "5.5.0.0";

  src = fetchFromGitHub {
    owner = "meganz";
    repo = "MEGAsync";
    rev = "v${version}_Linux";
    hash = "sha256-f+FZdMMdGZvYvJZ0xTUuO9zk0/VHFAISvM2cW0zwfaE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    libtool
    pkg-config
    qttools
    unzip
  ];
  buildInputs = [
    c-ares
    cryptopp
    curl
    ffmpeg
    hicolor-icon-theme
    icu
    libmediainfo
    libsodium
    libuv
    libxcb
    libzen
    openssl
    qtbase
    qtdeclarative
    qtgraphicaleffects
    qtquickcontrols
    qtquickcontrols2
    qtsvg
    qtx11extras
    readline
    sqlite
    wget
    zlib
  ];

  patches = [
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/020-megasync-sdk-fix-cmake-dependencies-detection.patch?h=megasync&id=4b1eca5bc0d75709dee3a1260264d1b6386d3398";
      hash = "sha256-y3WhLkawFzQRzzRBpioiyAT3F1NDQvYBOm2888g5V5c=";
      extraPrefix = "src/MEGASync/mega/";
      stripLen = true;
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/030-megasync-app-fix-cmake-dependencies-detection.patch?h=megasync&id=4b1eca5bc0d75709dee3a1260264d1b6386d3398";
      hash = "sha256-11XWctv1veUEguc9Xvz2hMYw26CaCwu6M4hyA+5r81U=";
    })
    ./megasync-fix-cmake-install-bindir.patch
  ];

  postPatch = ''
    for file in $(find src/ -type f \( -iname configure -o -iname \*.sh \) ); do
      substituteInPlace "$file" --replace "/bin/bash" "${stdenv.shell}"
    done
  '';

  dontUseQmakeConfigure = true;
  enableParallelBuilding = true;

  cmakeFlags = [
    "-DCMAKE_MODULE_PATH:PATH=${src}/src/MEGASync/mega/contrib/cmake/modules/packages"
    (lib.cmakeBool "USE_PDFIUM" false) # PDFIUM is not in nixpkgs
    (lib.cmakeBool "USE_FREEIMAGE" false) # freeimage is insecure
  ];

  meta = with lib; {
    description = "Easy automated syncing between your computers and your MEGA Cloud Drive";
    homepage = "https://mega.nz/";
    license = licenses.unfree;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    maintainers = [ ];
  };
}
