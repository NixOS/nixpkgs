{
  lib,
  stdenv,
<<<<<<< HEAD
  fetchFromGitea,
=======
  fetchFromGitLab,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  libpcap,
}:

stdenv.mkDerivation rec {
  pname = "pcapc";
  version = "1.0.1";

<<<<<<< HEAD
  src = fetchFromGitea {
    domain = "codeberg.org";
=======
  src = fetchFromGitLab {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    owner = "post-factum";
    repo = "pcapc";
    rev = "v${version}";
    hash = "sha256-oDg9OSvi9aQsZ2SQm02NKAcppE0w5SGZaI13gdp7gv4=";
  };

  buildInputs = [ libpcap ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://gitlab.com/post-factum/pcapc";
    description = "Compile libpcap filter expressions into BPF opcodes";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    homepage = "https://gitlab.com/post-factum/pcapc";
    description = "Compile libpcap filter expressions into BPF opcodes";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "pcapc";
  };
}
