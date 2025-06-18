{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "colort";
  version = "unstable-2017-03-12";

  src = fetchFromGitHub {
    owner = "neeasade";
    repo = "colort";
    rev = "8470190706f358dc807b4c26ec3453db7f0306b6";
    sha256 = "10n8rbr2h6hz86hcx73f86pjbbfiaw2rvxsk0yfajnma7bpxgdxw";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Program for 'tinting' color values";
    homepage = "https://github.com/neeasade/colort";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.neeasade ];
    mainProgram = "colort";
  };
}
