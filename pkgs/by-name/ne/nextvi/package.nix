{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nextvi";
<<<<<<< HEAD
  version = "3.1";
=======
  version = "2.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "kyx0r";
    repo = "nextvi";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-joIb+kJd0Oe1Irpz5zo48G+27umrr3Q1kKoLwpRiD8w=";
=======
    hash = "sha256-1bo2Cqa+d16yNQPFAYejHP838KX/sK33yxJO31o7cAc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
