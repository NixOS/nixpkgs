{
  fetchFromGitHub,
  lib,
  python3,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cupp";
  version = "0-unstable-2026-07-17";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mebus";
    repo = "cupp";
    rev = "b77f1ae66c10ab2d0fa09c67017949fb5ba187aa";
    hash = "sha256-eNE8DUFtFFEfBsm3TrL3GcnBXPQ7x0kfzZHH49Jqy5w=";
  };

  postPatch = ''
    substituteInPlace cupp.py \
      --replace-fail /usr/bin/python3 ${lib.getExe python3} \
      --replace-fail cupp.cfg ${placeholder "out"}/lib/cupp.cfg
  '';

  installPhase = ''
    runHook preInstall

    install -D cupp.py $out/bin/${finalAttrs.meta.mainProgram}
    install -Dm644 cupp.cfg --target-directory=$out/lib

    runHook postInstall
  '';

  meta = {
    description = "Common User Passwords Profiler";
    homepage = "https://github.com/mebus/cupp";
    changelog = "https://github.com/mebus/cupp/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "cupp";
    platforms = lib.platforms.all;
  };
})
