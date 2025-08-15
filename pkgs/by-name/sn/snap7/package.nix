{
  stdenv,
  lib,
  fetchurl,
  _7zz,
}:

stdenv.mkDerivation rec {
  pname = "snap7";
  version = "1.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/snap7/${version}/snap7-full-${version}.7z";
    sha256 = "sha256-H0JwzehoSVd3ChCh0xHCJuZw2VicaYQakBLoGPe5+A4=";
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

  meta = with lib; {
    homepage = "https://snap7.sourceforge.net/";
    description = "Step7 Open Source Ethernet Communication Suite";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ freezeboy ];
    platforms = platforms.linux;
  };
}
