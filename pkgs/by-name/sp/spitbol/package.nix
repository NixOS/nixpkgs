{
  fetchFromGitHub,
  installShellFiles,
  lib,
  nasm,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "spitbol";
  version = "4.0f";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "spitbol";
    repo = "x64";
    tag = "v${version}";
    hash = "sha256-x7TUHgx/ar8TfWkfySBsEGaMnrB4bVEeRiuqvMqYLrY=";
  };

  nativeBuildInputs = [
    nasm
    installShellFiles
  ];

  # Fix buflen macro collision with glibc headers
  postPatch = ''
    substituteInPlace osint/extern32.h \
      --replace-fail '# define buflen 512' '# define SPITBOL_BUFLEN 512'
  '';

  outputs = [
    "out"
    "man"
  ];

  # Bootstrap instead of using prebuilt ./bin/sbl
  buildPhase = ''
    runHook preBuild
    make bootsbl
    make BASEBOL=./bootsbl spitbol
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 sbl $out/bin/spitbol
    installManPage spitbol.1
    runHook postInstall
  '';

  meta = {
    description = "SPeedy ImplemenTation of snoBOL4";
    homepage = "https://github.com/spitbol/x64";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ slotThe ];
    mainProgram = "spitbol";
  };
}
