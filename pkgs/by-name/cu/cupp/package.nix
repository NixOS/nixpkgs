{
  fetchFromGitHub,
  lib,
  ncurses,
  nix-update-script,
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

  buildInputs = [ python3 ];

  postPatch = ''
    substituteInPlace cupp.py \
      --replace-fail 'os.system("clear")' 'os.system("${lib.getExe' ncurses "clear"}")'
  '';

  # cupp.py looks up cupp.cfg next to its resolved path
  installPhase = ''
    runHook preInstall

    install -D cupp.py --target-directory=$out/share/cupp
    install -Dm644 cupp.cfg --target-directory=$out/share/cupp
    mkdir -p $out/bin
    ln -s ../share/cupp/cupp.py $out/bin/${finalAttrs.meta.mainProgram}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Common User Passwords Profiler";
    homepage = "https://github.com/mebus/cupp";
    changelog = "https://github.com/mebus/cupp/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "cupp";
    platforms = lib.platforms.all;
  };
})
