{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.3.1";
  pname = "snore";

  src = fetchFromGitHub {
    owner = "clamiax";
    repo = "snore";
    tag = finalAttrs.version;
    hash = "sha256-bKPGSePzp4XEZFY0QQr37fm3R1v3hLD6FeySFd7zNJc=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "'sleep' with feedback";
    homepage = "https://github.com/clamiax/snore";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cafkafk ];
    platforms = lib.platforms.unix;
    mainProgram = "snore";
  };
})
