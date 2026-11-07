{
  lib,
  stdenv,
  fetchFromGitHub,
  mlton,
}:

stdenv.mkDerivation {
  pname = "ceptre";
  version = "0-unstable-2024-08-26";

  src = fetchFromGitHub {
    owner = "chrisamaphone";
    repo = "interactive-lp";
    rev = "22df9ff622f3363824f345089a25016e2a897077";
    hash = "sha256-MKA/289KWIYzHW0RbHC0Q2fMJT45WcABZrNsCWKZr4Y=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ mlton ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ceptre $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Linear logic programming language for modeling generative interactive systems";
    mainProgram = "ceptre";
    homepage = "https://github.com/chrisamaphone/interactive-lp";
    maintainers = with lib.maintainers; [
      NotAShelf
      pSub
    ];
    platforms = lib.platforms.unix;
    license = lib.licenses.unfree;
  };
}
