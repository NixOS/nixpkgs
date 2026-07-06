{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rasm";
  version = "3.2.5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "EdouardBERGE";
    repo = "rasm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sLSODTaVxhybtkzRAjQw4bRSPhp9O69S5OzkEq/pK0M=";
  };

  nativeBuildInputs = [ installShellFiles ];

  # by default the EXEC variable contains `rasm.exe`
  makeFlags = [ "EXEC=rasm" ];

  installPhase = ''
    runHook preInstall

    installBin rasm

    runHook postInstall
  '';

  meta = {
    homepage = "http://rasm.wikidot.com/english-index:home";
    description = "Z80 assembler";
    mainProgram = "rasm";
    # use -n option to display all licenses
    license = lib.licenses.mit; # expat version
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.all;
  };
})
