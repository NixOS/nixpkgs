{
  lib,
  stdenv,
  asciidoctor,
  botan3,
  bzip2,
  cmake,
  fetchFromGitHub,
  gnupg,
  gtest,
  json_c,
  pkg-config,
  python3,
  sexpp,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rnp";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "rnpgp";
    repo = "rnp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jUh7BxRnB6KePCk1jIvKzXgxSmWdKlQYmxshZZY4SBQ";
  };

  buildInputs = [
    zlib
    bzip2
    json_c
    botan3
    sexpp
  ];

  patches = [
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DBUILD_SHARED_LIBS=on"
    "-DBUILD_TESTING=on"
    "-DDOWNLOAD_GTEST=off"
    "-DDOWNLOAD_RUBYRNP=off"
    "-DSYSTEM_LIBSEXPP=on"
  ];

  nativeBuildInputs = [
    asciidoctor
    cmake
    gnupg
    gtest
    pkg-config
    python3
  ];

  # NOTE: check-only inputs should ideally be moved to nativeCheckInputs, but it
  # would fail during buildPhase.
  # nativeCheckInputs = [ gtest python3 ];

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  preConfigure = ''
    echo "v${finalAttrs.version}" > version.txt
  '';

  meta = with lib; {
    homepage = "https://github.com/rnpgp/rnp";
    description = "High performance C++ OpenPGP library, fully compliant to RFC 4880";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ ribose-jeffreylau ];
  };
})
