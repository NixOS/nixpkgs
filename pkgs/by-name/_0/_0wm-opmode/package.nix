{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  serve,
  xsel,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "0wm-opmode";
  version = "0-unstable-2026-10-06";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lab0-cc";
    repo = "0WM-OpMode";
    rev = "7616d9c00138aa6c45dfa5c474015ace516f94d2";
    hash = "sha256-dpsUZT8SpOAWupnYBE4jTLIJnpRV17r6R2j52hTGcuM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r * $out

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${lib.getExe serve} $out/bin/0wm-opmode \
      --prefix PATH : ${lib.makeBinPath [ xsel ]} \
      --add-flags "--symlinks" \
      --set-default "OP_MODE_ADDRESS" "127.0.0.1" \
      --set-default "OP_MODE_PORT" "8001" \
      --add-flags '-l "tcp://$OP_MODE_ADDRESS:$OP_MODE_PORT"' \
      --chdir $out
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=(0-unstable-.*)"
    ];
  };

  meta = {
    description = "0WM operator frontend";
    homepage = "https://github.com/lab0-cc/0WM-OpMode";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "0wm-opmode";
  };
})
