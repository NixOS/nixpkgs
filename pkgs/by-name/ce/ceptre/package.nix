{
  lib,
  stdenv,
  fetchFromGitHub,
  mlton,
}:
stdenv.mkDerivation {
  pname = "ceptre";
  version = "0-unstable-2023-12-12";

  src = fetchFromGitHub {
    owner = "chrisamaphone";
    repo = "interactive-lp";
    rev = "1251d0773fff633708c8612e2077d6f7a5b633ba";
    hash = "sha256-EbhuAh2P4M94lNgqJr66bM/Kzf1LClPdGB+K1X85rLQ=";
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
    license = lib.licenses.acsl14;
    maintainers = with lib.maintainers; [
      pSub
      NotAShelf
    ];
    platforms = lib.platforms.unix;
  };
}
