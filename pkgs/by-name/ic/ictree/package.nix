{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "ictree";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "NikitaIvanovV";
    repo = "ictree";
    tag = "v${version}";
    hash = "sha256-77Wo6jN8VUGTXBuGL0a9kvSIixdyEQoxqqNsHq9jcWw=";
    fetchSubmodules = true;
  };

  makeFlags = [ "PREFIX=$(out)" ];

<<<<<<< HEAD
  meta = {
    description = "Like tree but interactive";
    homepage = "https://github.com/NikitaIvanovV/ictree";
    platforms = lib.platforms.unix;
    maintainers = [ ];
=======
  meta = with lib; {
    description = "Like tree but interactive";
    homepage = "https://github.com/NikitaIvanovV/ictree";
    platforms = platforms.unix;
    maintainers = with maintainers; [ foo-dogsquared ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "ictree";
  };
}
