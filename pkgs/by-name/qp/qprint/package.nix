{
  fetchurl,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "qprint";
  version = "1.1";

  src = fetchurl {
    url = "https://www.fourmilab.ch/webtools/qprint/qprint-${version}.tar.gz";
    sha256 = "1701cnb1nl84rmcpxzq11w4cyj4385jh3gx4aqxznwf8a4fwmagz";
  };

  doCheck = true;

  checkTarget = "wringer";

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
  '';

  meta = with lib; {
    homepage = "https://www.fourmilab.ch/webtools/qprint/";
    license = licenses.publicDomain;
    description = "Encode and decode Quoted-Printable files";
    mainProgram = "qprint";
    maintainers = [ maintainers.tv ];
    platforms = platforms.all;
  };

}
