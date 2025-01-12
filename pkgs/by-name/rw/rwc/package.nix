{
  stdenv,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "rwc";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rB20XKprd8jPwvXYdjIEr3/8ygPGCDAgLKbHfw0EgPk=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Report when files are changed";
    license = licenses.publicDomain;
    platforms = platforms.linux;
    maintainers = with maintainers; [ somasis ];
    mainProgram = "rwc";
  };
}
