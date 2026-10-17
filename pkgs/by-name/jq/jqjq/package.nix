{
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

  nativeBuildInputs = [
    jq
    makeBinaryWrapper
  ];

  postPatch = ''
    patchShebangs jqjq.jq
  '';

  installPhase = ''
    runHook preInstall

    install -D jqjq.jq --target-directory="$out"/lib/jqjq
    mkdir "$out"/bin
    ln --symbolic \
      "$out"/{lib/jqjq/jqjq.jq,bin/${finalAttrs.meta.mainProgram}}
    wrapProgram "$_" --set JQ ${lib.getExe jqBootstrap}

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "jq implementation in [jq](https://jqlang.org)";
    homepage = "https://github.com/wader/jqjq";
    license = lib.licenses.mit;
    mainProgram = "jqjq";
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = lib.platforms.all;
  };
})
