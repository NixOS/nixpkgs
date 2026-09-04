{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bash,
  coreutils,
  gawk,
  gnused,
  makeWrapper,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "arkanoid-bash";
  version = "0-unstable-2025-02-10";

  src = fetchFromGitHub {
    owner = "bolknote";
    repo = "shellgames";
    rev = "3e43ec2329ac4dec5f5150832929371759aba9fd";
    hash = "sha256-0pRe+3JM1xTFcX/sWW2BQFlEJcMcv/94RWkRqs5inV0=";
  };

  strictDeps = true;

  postPatch = ''
    substituteInPlace arcanoid.sh \
      --replace-fail \
        'pkill -F <(printf "%d" $CHILD) bash' \
        'kill "$CHILD"'
  '';

  nativeBuildInputs = [ makeWrapper ];

  doCheck = stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform;
  checkPhase = ''
    runHook preCheck

    ${stdenvNoCC.shellDryRun} arcanoid.sh

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 arcanoid.sh -t "$out/share/arkanoid-bash"
    install -Dm644 README -t "$out/share/doc/arkanoid-bash"

    makeWrapper ${bash}/bin/bash "$out/bin/arkanoid-bash" \
      --add-flags "$out/share/arkanoid-bash/arcanoid.sh" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          gawk
          gnused
        ]
      }"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Arkanoid-style terminal game written in Bash";
    homepage = "https://github.com/bolknote/shellgames";
    license = lib.licenses.unfree;
    mainProgram = "arkanoid-bash";
    maintainers = with lib.maintainers; [ Zaczero ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
