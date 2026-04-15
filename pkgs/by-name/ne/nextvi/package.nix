{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nextvi";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "kyx0r";
    repo = "nextvi";
    tag = finalAttrs.version;
    hash = "sha256-pkVUCWWVzPwPEG4NGWOoHrXkQpC245kD/Xbj9wmxR3E=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildPhase = ''
    runHook preBuild

    sh ./cbuild.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    PREFIX=$out sh ./cbuild.sh install

    mv $out/bin/{vi,nextvi}
    installManPage --name nextvi.1 vi.1

    runHook postInstall
  '';

  meta = {
    description = "Next version of neatvi (a small vi/ex editor)";
    homepage = "https://github.com/kyx0r/nextvi";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.sikmir ];
    mainProgram = "nextvi";
  };
})
