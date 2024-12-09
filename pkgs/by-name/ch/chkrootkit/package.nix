{ lib, stdenv, fetchurl, makeWrapper, binutils-unwrapped }:

stdenv.mkDerivation rec {
  pname = "chkrootkit";
  version = "0.58b";

  src = fetchurl {
    url = "ftp://ftp.chkrootkit.org/pub/seg/pac/${pname}-${version}.tar.gz";
    sha256 = "sha256-de0qzoHw+j6cP7ZNqw6IV+1ZJH6nVfWJhBb+ssZoB7k=";
  };

  # TODO: a lazy work-around for linux build failure ...
  makeFlags = [ "STATIC=" ];

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace chkrootkit \
      --replace " ./" " $out/bin/"
  '';

  installPhase = ''
    mkdir -p $out/sbin
    cp check_wtmpx chkdirs chklastlog chkproc chkrootkit chkutmp chkwtmp ifpromisc strings-static $out/sbin

    wrapProgram $out/sbin/chkrootkit \
      --prefix PATH : "${lib.makeBinPath [ binutils-unwrapped ]}"
  '';

  meta = with lib; {
    description = "Locally checks for signs of a rootkit";
    homepage = "https://www.chkrootkit.org/";
    license = licenses.bsd2;
    platforms = with platforms; linux;
  };
}
