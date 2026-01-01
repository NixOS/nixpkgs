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
    repo = "rwc";
    rev = "v${version}";
    sha256 = "sha256-rB20XKprd8jPwvXYdjIEr3/8ygPGCDAgLKbHfw0EgPk=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

<<<<<<< HEAD
  meta = {
    description = "Report when files are changed";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ somasis ];
=======
  meta = with lib; {
    description = "Report when files are changed";
    license = licenses.publicDomain;
    platforms = platforms.linux;
    maintainers = with maintainers; [ somasis ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "rwc";
  };
}
