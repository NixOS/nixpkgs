{ lib, fetchurl, stdenv, zlib, ncurses, libiconv }:

stdenv.mkDerivation rec {
  pname = "fnc";
  version = "0.10";

  src = fetchurl {
    url = "https://fnc.bsdbox.org/tarball/${version}/fnc-${version}.tar.gz";
    sha256 = "1phqxh0afky7q2qmhgjlsq1awbv4254yd8wpzxlww4p7a57cp0lk";
  };

  buildInputs = [ libiconv ncurses zlib ];

  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    test "$($out/bin/fnc --version)" = '${pname} ${version}'
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Interactive ncurses browser for Fossil repositories";
    longDescription = ''
      An interactive ncurses browser for Fossil repositories.

      fnc uses libfossil to create a fossil ui experience in the terminal.
    '';
    homepage = "https://fnc.bsdbox.org";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbe ];
  };
}
