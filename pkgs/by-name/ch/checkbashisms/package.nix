{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
  perl,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.23.7";
  pname = "checkbashisms";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/devscripts/devscripts_${finalAttrs.version}.tar.xz";
    hash = "sha256-nOnlE1Ry2GR+L/tWZV4AOR6Omap6SormBc8OH/2fNgk=";
  };

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ perl ];

  buildPhase = ''
    runHook preBuild

    substituteInPlace ./scripts/checkbashisms.pl \
      --replace '###VERSION###' "$version"

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    installManPage scripts/$pname.1
    installShellCompletion --bash --name $pname scripts/$pname.bash_completion
    install -D -m755 scripts/$pname.pl $out/bin/$pname

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
