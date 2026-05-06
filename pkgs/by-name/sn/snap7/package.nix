{
  stdenv,
  lib,
  fetchurl,
  _7zz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snap7";
  version = "1.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/snap7/${finalAttrs.version}/snap7-full-${finalAttrs.version}.7z";
    hash = "sha256-H0JwzehoSVd3ChCh0xHCJuZw2VicaYQakBLoGPe5+A4=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [
    _7zz
  ];

  makefile = "x86_64_linux.mk";
  makeFlags = [
    "-C build/unix"
    "LibInstall=$(out)/lib"
  ];

  preInstall = ''
    mkdir -p $out/lib
    mkdir -p $dev/include
    mkdir -p $doc/share
    cp examples/cpp/snap7.h $dev/include
    cp -r doc $doc/share/
  '';

  meta = {
    homepage = "https://snap7.sourceforge.net/";
    description = "Step7 Open Source Ethernet Communication Suite";
    license = lib.licenses.lgpl3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
