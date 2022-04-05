{ lib
, mkDerivation
, fetchFromGitHub
, fetchpatch
, cmake
, extra-cmake-modules
, qtbase
, qtquickcontrols2
, SDL
, python3
, catch2
, callPackage
, nixosTests
}:

mkDerivation rec {
  pname = "sfxr-qt";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "agateau";
    repo = "sfxr-qt";
    rev = version;
    sha256 = "sha256-Ce5NJe1f+C4pPmtenHYvtkxste+nPuxJoB+N7K2nyRo=";
    fetchSubmodules = true;
  };

  postPatch = ''
    cp ${catch2}/include/catch2/catch.hpp 3rdparty/catch2/single_include/catch2/catch.hpp
  '';

  # Remove on next release
  patches = [(fetchpatch {
    name = "sfxr-qr-missing-qpainterpath-include";
    url = "https://github.com/agateau/sfxr-qt/commit/ef051f473654052112b647df987eb263e38faf47.patch";
    sha256 = "sha256-bqMnxHUzdS5oG/2hfr5MvkpwrtZW+GTN5fS2WpV2W2c=";
  })];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    (python3.withPackages (pp: with pp; [ pyyaml jinja2 setuptools ]))
  ];

  buildInputs = [
    qtbase
    qtquickcontrols2
    SDL
  ];

  doCheck = true;

  passthru.tests = {
    export-square-wave = callPackage ./test-export-square-wave {};
    sfxr-qt-starts = nixosTests.sfxr-qt;
  };

  meta = with lib; {
    homepage = "https://github.com/agateau/sfxr-qt";
    description = "A sound effect generator, QtQuick port of sfxr";
    license = licenses.gpl2;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.linux;
  };
}
