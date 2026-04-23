{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  writeShellApplication,
  curl,
  jq,
  common-updater-scripts,
}:

python3Packages.buildPythonApplication {
  pname = "lichess-bot";
  version = "2026.4.15.1";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "lichess-bot-devs";
    repo = "lichess-bot";
    rev = "55200ddb52746b87cff3756526c96c8d4f05feb6";
    hash = "sha256-HaVDUYEnS1ZC26AXr4CmKY4+1nr59w40+eGDgpOEsKA=";
  };

  propagatedBuildInputs = with python3Packages; [
    chess
    pyyaml
    requests
    backoff
    rich
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/{bin,share/lichess-bot}
    cp -R . $out/share/lichess-bot

    makeWrapper ${python3Packages.python.interpreter} $out/bin/lichess-bot \
      --set PYTHONPATH "$PYTHONPATH:$out/share/lichess-bot" \
      --add-flags "$out/share/lichess-bot/lichess-bot.py"
    echo $out > $out/my_dir.txt

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--disable_auto_logging";
  doInstallCheck = true;

  passthru = {
    updateScript = lib.getExe (writeShellApplication {
      name = "lichess-bot-update-script";

      runtimeInputs = [
        curl
        jq
        common-updater-scripts
      ];

      text = ''
        commit_msg='^Auto update version to (?<ver>[0-9.]+)$'
        commit="$(
          curl -s 'https://api.github.com/repos/lichess-bot-devs/lichess-bot/commits?path=lib/versioning.yml' | \
          jq -c "map(select(.commit.message | test(\"$commit_msg\"))) | first"
        )"
        rev="$(jq -r '.sha' <<< "$commit")"
        version="$(jq -r ".commit.message | capture(\"$commit_msg\") | .ver" <<< "$commit")"

        update-source-version lichess-bot "$version" --rev="$rev"
      '';
    });
  };

  meta = {
    description = "Bridge between lichess.org and bots";
    homepage = "https://github.com/lichess-bot-devs/lichess-bot";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ mse63 ];
    platforms = lib.platforms.unix;
    mainProgram = "lichess-bot";
  };

}
