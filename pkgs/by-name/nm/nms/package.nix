{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "nms";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "bartobri";
    repo = "no-more-secrets";
    rev = "v${version}";
    sha256 = "sha256-QVCEpplsZCSQ+Fq1LBtCuPBvnzgLsmLcSrxR+e4nA5I=";
  };

  buildFlags = [
    "nms"
    "sneakers"
  ];
  installFlags = [ "prefix=$(out)" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/bartobri/no-more-secrets";
    description = ''
      A command line tool that recreates the famous data decryption
      effect seen in the 1992 movie Sneakers.
    '';
<<<<<<< HEAD
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
=======
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
