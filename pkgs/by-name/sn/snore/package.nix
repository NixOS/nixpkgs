{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  version = "0.3.1";
  pname = "snore";

  src = fetchFromGitHub {
    owner = "clamiax";
    repo = "snore";
    tag = version;
    hash = "sha256-bKPGSePzp4XEZFY0QQr37fm3R1v3hLD6FeySFd7zNJc=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

<<<<<<< HEAD
  meta = {
    description = "'sleep' with feedback";
    homepage = "https://github.com/clamiax/snore";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cafkafk ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "'sleep' with feedback";
    homepage = "https://github.com/clamiax/snore";
    license = licenses.mit;
    maintainers = with maintainers; [ cafkafk ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "snore";
  };
}
