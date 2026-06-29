{
  lib,
  fetchFromGitLab,
  stdenvNoCC,
  nix-update-script,
  installShellFiles,
  makeWrapper,
  perl,
  gnupg,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jetring";
  version = "0.32";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "jetring";
    tag = "debian/${finalAttrs.version}";
    hash = "sha256-oaZXy/BO0mDYvDPW0OP38fXZTZSrcUCW7uYuwCMBPDc=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  buildInputs = [
    perl
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    installBin jetring-{accept,apply,build,diff,explode,gen,review,signindex,checksum}

    for f in $out/bin/*; do
      wrapProgram "$f" --prefix PATH : ${lib.makeBinPath [ gnupg ]}
    done

    installManPage *.{1,7}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Maintenance of gpg keyrings using changesets";
    homepage = "https://salsa.debian.org/debian/jetring";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    badPlatforms = [ "x86_64-freebsd" ];
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
