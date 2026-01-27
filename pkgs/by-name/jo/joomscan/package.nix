{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  makeWrapper,
}:

let
  p = perl.withPackages (
    ps: with ps; [
      LWP
      LWPProtocolHttps
    ]
  );
in
stdenv.mkDerivation {
  pname = "joomscan";
  version = "0.0.7-unstable-2023-11-30";

  src = fetchFromGitHub {
    owner = "owasp";
    repo = "joomscan";
    rev = "2ea8cc7792b3893b80a52e4ad7cc32a1a9dbf7fc";
    sha256 = "sha256-Rmcp6Z2Na5Ro2C6GP8RWCpXDwEu75sJDMfcQyFDGPLQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r . $out/share/joomscan
    makeWrapper ${p}/bin/perl $out/bin/joomscan.pl \
      --add-flags $out/share/joomscan/joomscan.pl

    runHook postInstall
  '';

  meta = {
    description = "Joomla Vulnerability Scanner";
    homepage = "https://wiki.owasp.org/index.php/Category:OWASP_Joomla_Vulnerability_Scanner_Project";
    mainProgram = "joomscan.pl";
    maintainers = with lib.maintainers; [ emilytrau ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
  };
}
