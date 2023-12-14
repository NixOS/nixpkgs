{ lib, stdenv, fetchFromGitHub, fetchurl, python3Packages, python3 }:

python3Packages.buildPythonPackage rec {
  pname = "openbb-terminal";
  version = "3.2.4";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "OpenBB-finance";
    repo = "OpenBBTerminal";
    rev = "v${version}";
    hash = "sha256-beUSV0ieLePgTC+PP66C+/ZscREFT3p/3Q3aTpkRvxk=";
  };

  prePatch = ''
    # remove hardcoded setuptools version
    substituteInPlace pyproject.toml \
      --replace 'setuptools = "<65.5.0"' 'setuptools = "*"' \
      --replace 'requires = ["setuptools<65.5.0", "poetry-core>=1.0.0"]' 'requires = ["poetry-core>=1.0.0"]'

    # fix bs4 import
    substituteInPlace pyproject.toml \
      --replace "bs4" "beautifulsoup4"

    # add in empty env vars files, otherwise app will try to write to read-only dir
    echo "" > .env
    echo "" > openbb_terminal/.env
    substituteInPlace openbb_terminal/core/config/paths_helper.py \
      --replace "SETTINGS_ENV_FILE," "" \
      --replace "REPOSITORY_ENV_FILE," ""

    # disable sending telemetry (on slow networks this makes the application very slow otherwise)
    substituteInPlace openbb_terminal/loggers.py \
      --replace '"""Send log record to Posthog"""' "return"
  '';

  patches = [ ./0001-check-if-directory-exists.patch ];

  # Download plotly js file, as otherwise python will attempt to write it to a read-only dir
  plotlyJs = fetchurl {
    url = "https://cdn.plot.ly/plotly-2.24.2.min.js";
    hash = "sha256-MdBjrZIx07e6B/WFACQSFtsacDzTAjZpaWAbscM9s2Q=";
  };

  postPatch = ''
    mkdir -p openbb_terminal/core/plots/assets
    cp ${plotlyJs} openbb_terminal/core/plots/assets/plotly-2.24.2.min.js
  '';

  nativeBuildInputs = with python3Packages; [ poetry-core setuptools ];

  propagatedBuildInputs = with python3Packages; [
    numpy
    pandas
    plotly
    statsmodels
    python-i18n
    python-dotenv
    posthog
    rich
    pydantic
    aiohttp
    reportlab
    svglib
    pywry
    pandas-ta
    beautifulsoup4
    iso8601
    yfinance
    holidays
    langchain
    llama_index
    screeninfo
    prompt-toolkit
    python-jose
    feedparser
    ccxt
    pycoingecko
    financedatabase
    fundamentalanalysis
    intrinio_sdk
    nbformat
    papermill
    ipykernel
    detecta
    pandas-market-calendars
  ];

  meta = with lib; {
    description =
      "The first financial terminal that is free and fully open source.";
    homepage = "https://openbb.co/";
    changelog =
      "https://github.com/OpenBB-finance/OpenBBTerminal/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
