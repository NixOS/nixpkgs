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
stdenv.mkDerivation rec {
  pname = "joomscan";
  version = "unstable-2021-06-08";

  src = fetchFromGitHub {
    owner = "owasp";
    repo = pname;
    rev = "79315393509caa39895e553c489667636ac31b85";
    sha256 = "Yg91iUhqbKZyPghiX0UZ7S1ql0DZLtPHOk9VEY1ZZOg=";
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

  meta = with lib; {
    description = "Joomla Vulnerability Scanner";
    homepage = "https://wiki.owasp.org/index.php/Category:OWASP_Joomla_Vulnerability_Scanner_Project";
    mainProgram = "joomscan.pl";
    maintainers = with maintainers; [ emilytrau ];
    license = licenses.gpl3Only;
    platforms = platforms.all;
  };
}
