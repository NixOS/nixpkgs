{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "lichess-bot";
  version = "2025.12.23.1";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "lichess-bot-devs";
    repo = "lichess-bot";
    rev = "6ea42dfaffa65efea0da09d94b058853d724a989";
    hash = "sha256-G8DiW96mRnvmmmRALRcYDnjLilQIRqH5m6+aTluhohI=";
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

    substituteInPlace "lib/lichess_bot.py" \
      --replace 'open("lib/versioning.yml")' \
                'open("'$out'/share/lichess-bot/lib/versioning.yml")'


    mkdir -p "$out"/{bin,share/lichess-bot}
    cp -R . $out/share/lichess-bot

    makeWrapper ${python3Packages.python.interpreter} $out/bin/lichess-bot \
      --set PYTHONPATH "$PYTHONPATH:$out/share/lichess-bot" \
      --add-flags "$out/share/lichess-bot/lichess-bot.py"
    echo $out > $out/my_dir.txt

    runHook postInstall
  '';

  meta = {
    description = "Bridge between lichess.org and bots";
    homepage = "https://github.com/lichess-bot-devs/lichess-bot";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ mse63 ];
    platforms = lib.platforms.unix;
    mainProgram = "lichess-bot";
  };

}
