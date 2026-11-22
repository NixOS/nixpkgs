{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
  perl,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "checkbashisms";
  version = "2.25.10";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/devscripts/devscripts_${finalAttrs.version}.tar.xz";
    hash = "sha256-pEzXrKV/bZbYG7j5QXjRDATZRGLt0fhdpwTDbCoKcus=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ perl ];

  buildPhase = ''
    runHook preBuild

    substituteInPlace ./scripts/checkbashisms.pl \
      --replace-fail '###VERSION###' "${finalAttrs.version}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    installManPage scripts/checkbashisms.1
    installShellCompletion --bash --name checkbashisms scripts/checkbashisms.bash_completion
    install -D -m755 scripts/checkbashisms.pl $out/bin/checkbashisms

    runHook postInstall
  '';

  passthru.tests = {
    version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    homepage = "https://sourceforge.net/projects/checkbaskisms/";
    changelog = "https://salsa.debian.org/debian/devscripts/-/blob/v${finalAttrs.version}/debian/changelog";
    description = "Check shell scripts for non-portable syntax";
    mainProgram = "checkbashisms";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ kaction ];
    platforms = lib.platforms.unix;
  };
})
