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
  version = "0-unstable-2026-03-30";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "jqjq";
    rev = "adfc53104329c4a4ec81ac30552ccddb3a9fc5eb";
    hash = "sha256-PPYJ8VFhvVUj7WdMdj5HzU23o/oPekfzgNgAdSD9o24=";
  };

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
