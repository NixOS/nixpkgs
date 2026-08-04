{
  lib,
  fetchFromGitHub,
  python3Packages,
  withFreqUI ? true,
  withPlot ? false,
  withFreqAI ? false,
  withFreqAIRL ? false,
  withHyperopt ? false,
}:

let
  ft-pandas-ta = python3Packages.callPackage ./ft-pandas-ta.nix { };
  technical = python3Packages.callPackage ./technical.nix { };
  freqtrade-client = python3Packages.callPackage ./client.nix { };
  frequi = python3Packages.callPackage ./frequi.nix { };
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "freqtrade";
  version = "2026.6";
  src = fetchFromGitHub {
    owner = "freqtrade";
    repo = "freqtrade";
    tag = finalAttrs.version;
    hash = "sha256-phxhnwijuvsPsRGsGxOp+RNLNBOIVXU3siBC+O9QJLg=";
  };
  __structuredAttrs = true;
  pyproject = true;
  build-system = with python3Packages; [
    setuptools
    wheel
  ];
  dependencies =
    with python3Packages;
    [
      ccxt
      sqlalchemy
      python-telegram-bot
      humanize
      cachetools
      requests
      httpx
      urllib3
      jsonschema
      scipy
      numpy
      pandas
      ta-lib
      ft-pandas-ta
      technical
      tabulate
      pycoingecko
      python-rapidjson
      orjson
      jinja2
      questionary
      prompt-toolkit
      joblib
      rich
      pyarrow
      fastapi
      pydantic
      pyjwt
      websockets
      uvicorn
      psutil
      schedule
      janus
      ast-comments
      aiofiles
      aiohttp
      cryptography
      sdnotify
      python-dateutil
      pytz
      packaging
      freqtrade-client
    ]
    ++ lib.optionals withPlot finalAttrs.passthru.optional-dependencies.plot
    ++ lib.optionals withFreqAI finalAttrs.passthru.optional-dependencies.freqAI
    ++ lib.optionals withFreqAIRL finalAttrs.passthru.optional-dependencies.freqAIRL
    ++ lib.optionals withHyperopt finalAttrs.passthru.optional-dependencies.hyperopt;
  optional-dependencies = with python3Packages; {
    plot = [ plotly ];
    freqAI = [
      scikit-learn
      joblib
      lightgbm
      xgboost
      tensorboard
      datasieve
    ];
    freqAIRL = [
      torch
      gymnasium
      stable-baselines3
      sb3-contrib
      tqdm
    ];
    hyperopt = [
      scikit-learn
      filelock
      optuna
      cmaes
    ];
  };
  postInstall = lib.optionalString withFreqUI ''
    # https://github.com/freqtrade/freqtrade/blob/064e67c42af3c4026d123990f992ac42f7ee3cde/freqtrade/commands/deploy_commands.py#L117
    ln -s ${frequi} $out/${python3Packages.python.sitePackages}/freqtrade/rpc/api_server/ui/installed
  '';
  meta = {
    description = "Free, open source crypto trading bot";
    longDescription = "Freqtrade is a free and open source crypto trading bot written in Python. It is designed to support all major exchanges and be controlled via Telegram or webUI. It contains backtesting, plotting and money management tools as well as strategy optimization by machine learning.";
    homepage = "https://www.freqtrade.io";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ n0099 ];
    mainProgram = "freqtrade";
  };
})
