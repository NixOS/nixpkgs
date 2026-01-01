{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "fet-sh";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "6gk";
    repo = "fet.sh";
    rev = "v${version}";
    sha256 = "sha256-xhX2nVteC3T3IjQh++mYlm0btDJQbyQa6b8sGualV0E=";
  };

  postPatch = ''
    patchShebangs fet.sh
  '';

  installPhase = ''
    install -m755 -D fet.sh $out/bin/fet.sh
  '';

<<<<<<< HEAD
  meta = {
    description = "Fetch written in posix shell without any external commands";
    homepage = "https://github.com/6gk/fet.sh";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ elkowar ];
=======
  meta = with lib; {
    description = "Fetch written in posix shell without any external commands";
    homepage = "https://github.com/6gk/fet.sh";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ elkowar ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "fet.sh";
  };
}
