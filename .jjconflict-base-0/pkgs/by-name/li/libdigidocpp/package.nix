{
  lib,
  stdenv,
  fetchurl,
  cmake,
  libtool,
  libxml2,
  minizip,
  pcsclite,
  opensc,
  openssl,
  xercesc,
  pkg-config,
  xsd,
  zlib,
  xmlsec,
  xxd,
}:

stdenv.mkDerivation rec {
  version = "4.0.0";
  pname = "libdigidocpp";

  src = fetchurl {
    url = "https://github.com/open-eid/libdigidocpp/releases/download/v${version}/libdigidocpp-${version}.tar.gz";
    hash = "sha256-0G7cjJEgLJ24SwHRznKJ18cRY0m50lr6HXstfbYq9f8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    xxd
  ];

  buildInputs = [
    libxml2
    minizip
    pcsclite
    opensc
    openssl
    xercesc
    xsd
    zlib
    xmlsec
  ];

  outputs = [
    "out"
    "lib"
    "dev"
    "bin"
  ];

  # This wants to link to ${CMAKE_DL_LIBS} (ltdl), and there doesn't seem to be
  # a way to tell CMake where this should be pulled from.
  # A cleaner fix would probably be to patch cmake to use
  # `-L${libtool.lib}/lib -ltdl` for `CMAKE_DL_LIBS`, but that's a world rebuild.
  env.NIX_LDFLAGS = "-L${libtool.lib}/lib";

  # libdigidocpp.so's `PKCS11Signer::PKCS11Signer()` dlopen()s "opensc-pkcs11.so"
  # itself, so add OpenSC to its DT_RUNPATH after the fixupPhase shrinked it.
  # https://github.com/open-eid/cmake/pull/35 might be an alternative.
  postFixup = ''
    patchelf --add-rpath ${opensc}/lib/pkcs11 $lib/lib/libdigidocpp.so
  '';

  meta = with lib; {
    description = "Library for creating DigiDoc signature files";
    mainProgram = "digidoc-tool";
    homepage = "https://www.id.ee/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
