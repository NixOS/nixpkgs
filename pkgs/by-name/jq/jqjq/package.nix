{
  bashNonInteractive,
  coreutils,
  fetchFromGitHub,
  jq,
  jqBootstrap ? jq,
  lib,
  makeBinaryWrapper,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jqjq";
  version = "0-unstable-2026-08-02";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "jqjq";
    rev = "644d9650359eaef9d82bdd2cb146a54e891a0538";
    hash = "sha256-k3mznsq2Dmbs8Dz6weSpK5rCZ91ITU0HXl0LUT4Klvk=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  # Interpreters for patchShebangs on "#!/usr/bin/env -S bash"
  buildInputs = [
    bashNonInteractive
    coreutils
  ];

  # Default target of the Makefile only runs the test suite
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D jqjq.jq --target-directory="$out"/lib/jqjq
    # jqjq runs its host jq by the name jq.  Link the chosen implementation
    # under that name, because setting $JQ would override jqjq's own --jq
    # option.
    mkdir --parents "$out"/libexec/jqjq
    ln --symbolic ${lib.getExe jqBootstrap} "$out"/libexec/jqjq/jq
    makeWrapper "$out"/lib/jqjq/jqjq.jq \
      "$out"/bin/${finalAttrs.meta.mainProgram} \
      --prefix PATH : "$out"/libexec/jqjq:${lib.makeBinPath [ coreutils ]}

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    "$out"/bin/${finalAttrs.meta.mainProgram} --run-tests <jqjq.test

    runHook postInstallCheck
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "jq implementation in jq";
    homepage = "https://github.com/wader/jqjq";
    license = lib.licenses.mit;
    mainProgram = "jqjq";
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = lib.platforms.all;
  };
})
