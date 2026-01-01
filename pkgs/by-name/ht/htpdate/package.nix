{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  version = "2.0.1";
  pname = "htpdate";

  src = fetchFromGitHub {
    owner = "twekkel";
    repo = "htpdate";
    rev = "v${version}";
    sha256 = "sha256-dl3xlwk2q1DdGrIQsbKwdYDjyhGxpYwQGcd9k91LkxA=";
  };

  makeFlags = [
    "prefix=$(out)"
  ];

<<<<<<< HEAD
  meta = {
    description = "Utility to fetch time and set the system clock over HTTP";
    homepage = "https://github.com/twekkel/htpdate";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ julienmalka ];
=======
  meta = with lib; {
    description = "Utility to fetch time and set the system clock over HTTP";
    homepage = "https://github.com/twekkel/htpdate";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ julienmalka ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "htpdate";
  };
}
