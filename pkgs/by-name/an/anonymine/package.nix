{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  coreutils,
  makeWrapper,
  python3,
  nix-update-script,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "anonymine";
  version = "0.5.5";

  src = fetchFromGitLab {
    owner = "oskog97";
    repo = "anonymine";
    rev = "6b3640662eb17c9060e49a38a584271c53461b57";
    hash = "sha256-n92lsdQ1a/DB2G/+oZVHbKNHNX35wuP1xlq9rWBPI4g=";
  };

  strictDeps = true;

  postPatch = ''
    substituteInPlace anonymine.py \
      --replace-fail "MAKEFILE_GAME_VERSION" "${finalAttrs.version}" \
      --replace-fail "MAKEFILE_CFGDIR" "$out/share/anonymine"
  '';

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    ./installtools/mkenginecfg hiscores.txt

    install -Dm644 anonymine.py "$out/share/anonymine/anonymine.py"
    install -Dm644 anonymine_*.py -t "$out/share/anonymine/"
    install -Dm644 cursescfg -t "$out/share/anonymine/"
    install -Dm644 enginecfg.built "$out/share/anonymine/enginecfg"

    makeWrapper ${python3.interpreter} "$out/bin/anonymine" \
      --add-flags "$out/share/anonymine/anonymine.py" \
      --prefix PATH : ${lib.makeBinPath [ coreutils ]}

    install -Dm644 README.md ChangeLog -t "$out/share/doc/anonymine/"
    install -Dm644 LICENSE -t "$out/share/licenses/anonymine/"
    cp -a doc/. "$out/share/doc/anonymine/"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Curses mode minesweeper without guessing";
    homepage = "https://oskog97.com/projects/anonymine/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ Zaczero ];
    mainProgram = "anonymine";
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
