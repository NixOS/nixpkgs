{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

<<<<<<< HEAD
stdenv.mkDerivation {
  pname = "shine";
  version = "3.1.1-unstable-2023-01-01";
=======
stdenv.mkDerivation rec {
  pname = "shine";
  version = "3.1.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "toots";
    repo = "shine";
<<<<<<< HEAD
    rev = "ab5e3526b64af1a2eaa43aa6f441a7312e013519";
    hash = "sha256-rlKWVgIl/WVIzwwMuPyWaiwvbpZi5HvKXU3S6qLoN3I=";
=======
    rev = version;
    sha256 = "06nwylqqji0i1isdprm2m5qsdj4qiywcgnp69c5b55pnw43f07qg";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ autoreconfHook ];

<<<<<<< HEAD
  meta = {
    description = "Fast fixed-point mp3 encoding library";
    mainProgram = "shineenc";
    homepage = "https://github.com/toots/shine";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ dandellion ];
=======
  meta = with lib; {
    description = "Fast fixed-point mp3 encoding library";
    mainProgram = "shineenc";
    homepage = "https://github.com/toots/shine";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ dandellion ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
