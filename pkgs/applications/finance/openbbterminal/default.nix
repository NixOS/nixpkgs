{ stdenv
, lib
, pkgs
, fetchFromGitHub
, fetchPypi
, python3
}:

let
  FundamentalAnalysis = python3.pkgs.buildPythonPackage rec {
    pname = "fundamentalanalysis";
    version = "0.2.14";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-vD7nlI996BfhlbKsbTTca6nF9HgMnSm3downkOZ6tKQ=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      pandas
      requests
    ];

    doCheck = false;
  };

  riskfolio-lib = python3.pkgs.buildPythonPackage rec {
    pname = "riskfolio-lib";
    version = "4.0.3";

    src = fetchFromGitHub {
      owner = "dcajasn";
      repo = pname;
      rev = "bf7c471b3d768de6c41fc1376f8db1ee5c2c0abd";
      sha256 = "0m11mfz5nhvg483ldrmlrjhwaf284c0c0pxf0fb0sfx2dnjjj3ib";
    };
  };

  bt = python3.pkgs.buildPythonPackage rec {
    pname = "bt";
    version = "0.2.9";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-0WLXGqqvcmWoSNH8AED1A63TLawvnzEnvs4NdMIu+5s=";
    };
  };

  ccxt = python3.pkgs.buildPythonPackage rec {
    pname = "ccxt";
    version = "2.5.52";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-i7U0QTCpee10lZcdzMavz+JovjHCJ082DvY1ABq+ql4=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      certifi
      cryptography
      requests

      aiohttp
      aiodns
      yarl
    ];

    patchPhase = ''
      touch README.md
    '';
  };

  degiro-connector = python3.pkgs.buildPythonPackage rec {
    pname = "degiro-connector";
    version = "2.0.22";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-RrgUkkJplAUsXetuhhSPbLMtQz2OLF5y6P3Ek9oFfYI=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      protobuf
      wrapt
      onetimepass
      requests
      pandas
    ];

    buildInputs = with python3.pkgs; [
      pytest
      black
      mypy
      flake8
      grpcio-tools
      types-protobuf
      types-requests
      mypy-protobuf
      pytest-mock
    ];
  };

  detecta = python3.pkgs.buildPythonPackage rec {
    pname = "detecta";
    version = "0.0.5";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-0up9E9+7yZTWzjhaf43AqF/mdaio5xKmTsVuVMQGA+0=";
    };

    doCheck = false;

    propagatedBuildInputs = with python3.pkgs; [
      numpy
    ];
  };

  financedatabase = python3.pkgs.buildPythonPackage rec {
    pname = "financedatabase";
    version = "1.0.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-ewPTfvXu+EMzgNkhIvL9JLrXQZcVGOrxvUqcbzB2PiM=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      requests
    ];
  };

  finnhub-python = python3.pkgs.buildPythonPackage rec {
    pname = "finnhub-python";
    version = "2.4.15";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-Wp+cthVxeD7o9Jt3C0zpYuWvI37JIxgkuKhAO73QzvI=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      requests
    ];
  };

  user-agent = python3.pkgs.buildPythonPackage rec {
    pname = "user-agent";
    version = "0.1.10";

    src = fetchFromGitHub {
      owner = "lorien";
      repo = "user_agent";
      rev = "v${version}";
      sha256 = "sha256-uHgoN1JAq4Ay8lI9/PHOcVXvCShua+s1pC7RMrenuyA=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      six
    ];

    checkInputs = with python3.pkgs; [
      pytest
    ];
  };

  finviz = python3.pkgs.buildPythonPackage rec {
    pname = "finviz";
    version = "1.4.5";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-UkqXWh0sQQ0zRo5jIn558jGZ4wO2E+tTypMIR3p0NjQ=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      aiohttp
      tenacity
      urllib3
      user-agent
      lxml
      tqdm
      requests
      beautifulsoup4
      cssselect
      tenacity
      urllib3
    ];
  };

  datetime2 = python3.pkgs.buildPythonPackage rec {
    pname = "datetime2";
    version = "0.9.4";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-jaoHsucbLN3cXdAIO/o/OEA+lVeXjp6ZJdM21ZFd+bg=";
    };
  };

  datetime = python3.pkgs.buildPythonPackage rec {
    pname = "DateTime";
    version = "4.9";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-KdNGvz7K1e4arXT6LrA95V+imENOLyfbbcqhKkQ4VoE=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      zope_interface
      pytz
    ];
  };

  finvizfinance = python3.pkgs.buildPythonPackage rec {
    pname = "finvizfinance";
    version = "0.14.4";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-3ioU3MA3Gsk282WIEwPdTSFjkQtThPMVOrmckx09GhU=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      beautifulsoup4
      lxml
      pandas
      requests
      datetime
    ];

    patchPhase = ''
      cp README.md README_pypi.md
      sed -i "s/from bs4 //" finvizfinance/util.py
      sed -i "s/bs4/beautifulsoup4/" setup.py
      sed -i "s/bs4/beautifulsoup4/" requirements.txt
    '';

    doCheck = false;
  };

  fred = python3.pkgs.buildPythonPackage rec {
    pname = "fred";
    version = "3.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-8xMn1kiRdpS40V1myk6CoILbuIygJ73MnVZzjLyDamo=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      requests
    ];

    doCheck = false;
  };

  fredapi = python3.pkgs.buildPythonPackage rec {
    pname = "fredapi";
    version = "0.5.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-fhWptYK13KZ0BPCAfjUfjmOKpiBXOY42VGCKxbAh94I=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      pandas
    ];

    doCheck = false;
  };

  mkdocs-git-revision-date-localized-plugin = python3.pkgs.buildPythonPackage rec {
    pname = "mkdocs-git-revision-date-localized-plugin";
    version = "1.1.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-OFF+IIQinaGhuUYOhGwnSNI4wtee/UBdG5F0qHvYHXk=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      gitpython
      babel
      mkdocs
    ];
  };

  investiny = python3.pkgs.buildPythonPackage rec {
    pname = "investiny";
    version = "0.7.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-zbz+pz+T3yD7PJ1/1upY5ffiSLoNEwFn0n9gbMCedr8=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      pydantic
      httpx
      mkdocs
      mkdocs-material
      mkdocs-git-revision-date-localized-plugin
      mkdocstrings
      gitpython
    ];
  };

  investpy = python3.pkgs.buildPythonPackage rec {
    pname = "investpy";
    version = "1.0.8";

    format = "pyproject";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-anYyqUtITuB81Ur9QWvcdZzZBbpgxi27io0VcimyZ8Y=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      unidecode
      setuptools
      lxml
      numpy
      pandas
      pytz
      requests
    ];
  };

  ipyflex = python3.pkgs.buildPythonPackage rec {
    pname = "ipyflex";
    version = "0.2.6";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-MS/8H9XhmkIiBV/ydhyYlsQVs8kenFBGtjeyGMcuhXs=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      jupyter-packaging
      ipywidgets
    ];

    checkInputs = with python3.pkgs; [
      pytest
    ];
  };

  jupyterlab-code-formatter = python3.pkgs.buildPythonPackage rec {
    pname = "jupyterlab-code-formatter";
    version = "1.5.3";

    format = "pyproject";

    src = fetchFromGitHub {
      owner = "ryantam626";
      repo = "jupyterlab_code_formatter";
      rev = "v${version}";
      sha256 = "sha256-L+HezLwW+Gr9n0k9lsmsUnaWzOcnf4tqGVIeuSwtMYc=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      fredapi
      fred
      jupyter-packaging
    ];

    nativeBuildInputs = with pkgs; [
      yarn
    ];
  };

  pyhdfe = python3.pkgs.buildPythonPackage rec {
    pname = "pyhdfe";
    version = "0.1.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-e++r0uofZx+wL+RUyEOv+WZk2HSvFM5MJwJkyY1PhWw=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      numpy
      scipy
    ];

    checkInputs = with python3.pkgs; [
      pytest
    ];
  };

  linearmodels = python3.pkgs.buildPythonPackage rec {
    pname = "linearmodels";
    version = "4.27";

    src = pkgs.fetchgit {
      url = "https://github.com/bashtage/${pname}";
      rev = "f83d8d9f74058991e1816115ca1cf06e99d18589";
      sha256 = "sha256-Q9NbiIk1luZsr3oM/LuBH/vkHWsTf4C/RfPTflKgAKw=";
      leaveDotGit = true;
    };

    nativeBuildInputs = with pkgs; [
      git
      python3.pkgs.cython
    ];

    propagatedBuildInputs = with python3.pkgs; [
      mypy-extensions
      pyhdfe
      numpy
      pandas
      statsmodels
      property-cached
      setuptools_scm
      #(setuptools-scm.overrideAttrs (o: rec {
      #  version = "6.4.2";
      #  src = fetchFromGitHub {
      #    owner = "pypa";
      #    repo = "setuptools_scm";
      #    rev = "v${version}";
      #    sha256 = "sha256-xy08F/JvHRixBO7PP+9k/qEomVX8PRvoOwRSioWVR88=";
      #  };

      #  nativeBuildInputs = with pkgs; [
      #    git
      #    automake
      #    aclocal
      #  ];
      #}))
    ];

    checkInputs = with python3.pkgs; [
      pytest
    ];
  };

  property-cached = python3.pkgs.buildPythonPackage rec {
    pname = "property-cached";
    version = "1.6.4";

    src = fetchFromGitHub {
      owner = "althonos";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-8kityZ++1TS22Ff7a5x5bQi0QBaHsNaP4E/Man8A28A=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      freezegun
    ];
  };

  oandapyV20 = python3.pkgs.buildPythonPackage rec {
    pname = "oandapyV20";
    version = "0.7.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-XKOZD4JNCxav1J2OCPdAOGLSs8Wlg0cPd323928E0HM=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      protobuf
      fredapi
    ];

    doCheck = false;
  };

  pandas-market-calendars = python3.pkgs.buildPythonPackage rec {
    pname = "pandas_market_calendars";
    version = "4.1.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-40KQlX2r0ZLEsiXVhsGnN1pBxK5PW71pq7mO/mli3Rg=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      python-dateutil
      exchange-calendars
    ];
  };

  exchange-calendars = python3.pkgs.buildPythonPackage rec {
    pname = "exchange_calendars";
    version = "4.2.4";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-yk2u5fD2IKfsE1Xl+lpcwSmU9RZ3+/r/6e9cyROa9yc=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      numpy
      pandas
      python-dateutil
      pytz
      toolz
      korean-lunar-calendar
      pyluach
    ];

    doCheck = false;
  };

  pyluach = python3.pkgs.buildPythonPackage rec {
    pname = "pyluach";
    version = "2.0.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-l4lDEfGw1Z9fyrHRIUf4BJvOMVkV2NzYBr+/QclLUM8=";
    };

    propagatedBuildInputs = with python3.pkgs; [
    ];

    doCheck = false;
  };

  pandas-ta = python3.pkgs.buildPythonPackage rec {
    pname = "pandas-ta";
    version = "0.3.14";

    src = fetchFromGitHub {
      owner = "twopirllc";
      repo = pname;
      rev = version;
      sha256 = "sha256-1s4/u0oN596VIJD94Tb0am3P+WGosRv9ihD+OIMdIBE=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      pandas
    ];
  };

  psaw = python3.pkgs.buildPythonPackage rec {
    pname = "psaw";
    version = "0.1.0";

    src = fetchFromGitHub {
      owner = "dmarx";
      repo = pname;
      rev = "a3576596d3b8a4f15ff5b90f284696f545a69872";
      sha256 = "sha256-MyX42RHYsZuCpVRzM0RfJFnNQRpak//Cpb7vzv85Bdc=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      requests
      click
    ];
  };

  temporal-cache = python3.pkgs.buildPythonPackage rec {
    pname = "temporal-cache";
    version = "0.1.4";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-tt2FA1nEa9SlxZ/DuVP4kk5CmxF5o1GzUI0HwhRzi1A=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      tzlocal
      frozendict
      pytz
    ];

    doCheck = false;
  };

  pyEX = python3.pkgs.buildPythonPackage rec {
    pname = "pyEX";
    version = "0.5.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-6Fw5JzOuw3F7ANBWQL1+/PyHv5SQZKfzERIpP+OVwn4=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      deprecation
      pytz
      sseclient
      temporal-cache
      socketio-client-nexus
      ipython
      pillow
      pandas
    ];

    doCheck = false;
  };

  socketio-client-nexus = python3.pkgs.buildPythonPackage rec {
    pname = "socketIO-client-nexus";
    version = "0.7.6";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-Qeaqr/mB9nKWkPRy6yx6XR3aBzSQd+NERFJ7lwCwrqU=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      requests
      six
      websocket-client
    ];

    doCheck = false;
  };

  pyally = python3.pkgs.buildPythonPackage rec {
    pname = "pyally";
    version = "1.1.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-1dugZd2/GCYbg+KeX///cx2bA6QnjrmpMzoX8tF3LU0=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      requests-oauthlib
      pytz
    ];

    doCheck = false;
  };

  pycoingecko = python3.pkgs.buildPythonPackage rec {
    pname = "pycoingecko";
    version = "3.1.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-3MCFIsFg6IvR3rULurOQvjPc6Hq7EKkc5gE9Fb+FnBI=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      requests
    ];
  };

  pyinstaller = python3.pkgs.buildPythonPackage rec {
    pname = "pyinstaller";
    version = "5.7.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-DllTk3018LN1Q8xpFdrK8yOby98/0+y7eGZkVGihZ3U=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      pkgs.zlib
      pyinstaller-hooks-contrib
      altgraph
    ];

    doCheck = false;
  };

  pyinstaller-hooks-contrib = python3.pkgs.buildPythonPackage rec {
    pname = "pyinstaller-hooks-contrib";
    version = "2022.14";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-WujaOpLPION7PgBgTQw0aIlufXRuXBRJRzWXpyQzGws=";
    };
  };

  altgraph = python3.pkgs.buildPythonPackage rec {
    pname = "altgraph";
    version = "0.17.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-rTM1gRTffJQWzbj6HqpYUhZsUFEYcXAhxqjHx6u9A90=";
    };
  };

  pythclient = python3.pkgs.buildPythonPackage rec {
    pname = "pythclient";
    version = "0.1.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-4+JgQLwhRg3mJDeyFVzRY2LZlaGysx85uAP38cOWhOQ=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      loguru
      aiohttp
      backoff
      flake8
      dnspython
      base58
    ];
  };

  python-coinmarketcap = python3.pkgs.buildPythonPackage rec {
    pname = "python-coinmarketcap";
    version = "0.5";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-/8k3WbI6i602bR9PPey1k/3XRRvZC4DbcIpukQiqIgs=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      requests
    ];
  };

  robin-stocks = python3.pkgs.buildPythonPackage rec {
    pname = "robin-stocks";
    version = "2.1.0";

    src = fetchFromGitHub {
      owner = "jmfernandes";
      repo = "robin_stocks";
      rev = "143ecbc633d9c7885fe9584aaaca334aba0b475a";
      sha256 = "sha256-VssoAMgt6hd5lfr9Kpupo6XYz+hbpc3uDmF/yAbo+sM=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      pyotp
      python-dotenv
      requests
      cryptography
    ];
  };

  sentiment-investor = python3.pkgs.buildPythonPackage rec {
    pname = "sentiment-investor";
    version = "2.1.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-GxlpBY7VQO9wWaVMFGvHseQktVxAVgfUtAfUduViUE4=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      websocket-client
      beartype
      requests
    ];

    doCheck = false;
  };

  beartype = python3.pkgs.buildPythonPackage rec {
    pname = "beartype";
    version = "0.7.1";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-DqOwt5g+S9q7R60pmkuhHMSL6u2rr4l1Luony2FS5cE=";
    };

    doCheck = false;
  };

  squarify = python3.pkgs.buildPythonPackage rec {
    pname = "squarify";
    version = "0.4.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-VAkfatF19/IB+JNFdOZHzhtQ3txHjF/ZaGiOt9dGn5U=";
    };
  };

  stocksera = python3.pkgs.buildPythonPackage rec {
    pname = "stocksera";
    version = "0.1.21";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-MoATfP08AnZclFA0TpQPMdiH9RlDOsWjcJzoZxDdXNg=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      requests
      pandas
    ];
  };

  streamlit = python3.pkgs.buildPythonPackage rec {
    pname = "streamlit";
    version = "1.16.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-EfmPnIVPYRReeBCdLQaUNUEiE2IwOXorj9x9Z3iIPGA=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      packaging
    ];
  };

  thepassiveinvestor = python3.pkgs.buildPythonPackage rec {
    pname = "thepassiveinvestor";
    version = "1.0.11";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-zD1m8sW1CVTOpeWsdgRuRakyfp3lWGgmcj1w0zJMyYo=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      pandas
      yfinance
      openpyxl
    ];

    doCheck = false;
  };

  tokenterminal = python3.pkgs.buildPythonPackage rec {
    pname = "tokenterminal";
    version = "1.0.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-tjJ1XtESXYrvnYyMIycZFwQKRfx3XUVZ3Jnrq4nakSs=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      requests
    ];

    doCheck = false;
  };

  tradingview-ta = python3.pkgs.buildPythonPackage rec {
    pname = "tradingview-ta";
    version = "3.3.0";

    src = fetchFromGitHub {
      owner = "brian-the-dev";
      repo = "python-tradingview-ta";
      rev = "v${version}";
      sha256 = "sha256-ZNGnyenn7noNxecnPbcljss+18MRjIR+hnzp+nj3g4c=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      requests
    ];

    doCheck = false;
  };

  u8darts = python3.pkgs.buildPythonPackage rec {
    pname = "u8darts";
    version = "0.23.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-RVbzqC6SDMuLtw5vBa+gUUyPA1PSl+G2pqAiyzx++Cs=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      statsforecast
    ];
  };

  statsforecast = python3.pkgs.buildPythonPackage rec {
    pname = "statsforecast";
    version = "1.4.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-9Gi72AJmYBopandYBSHr/TEKDb4wEVO9FwgS/OdpF0A=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      numba
      plotly
      tqdm
      pandas
      numpy
      matplotlib
      statsmodels
      plotly-resampler
    ];
  };

  plotly-resampler = python3.pkgs.buildPythonPackage rec {
    pname = "plotly_resampler";
    version = "0.8.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-1laYbUWDcOqaNIYEKwC5QvMnRrXvFz1VeGt6R5EL2Ak=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      numpy
      trace-updater
      jupyter-dash
      pandas
      (werkzeug.overrideAttrs (o: rec {
        version = "2.1.2";
        src = fetchPypi {
          pname = "Werkzeug";
          inherit version;
          sha256 = "sha256-HOCOgJPtZ9Y41jh5/Rujc1gX96gN42dNKT9ZhPJftuY=";
        };
      }))
    ];

    doCheck = false;
  };

  jupyter-dash = python3.pkgs.buildPythonPackage rec {
    pname = "jupyter-dash";
    version = "0.4.2";

    src = fetchFromGitHub {
      owner = "plotly";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-YrTlmGH6BLX1W6Cgt+xbd6vKh0HCNhp8CkxVZJgayGY=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      retrying
      ipykernel
      ansi2html
      requests
      dash
    ];
  };

  trace-updater = python3.pkgs.buildPythonPackage rec {
    pname = "trace-updater";
    version = "0.0.9";

    src = fetchFromGitHub {
      owner = "predict-idlab";
      repo = pname;
      rev = "b443d8bac9e885e7a0c7a2516109c475a249a10c";
      sha256 = "sha256-RVOPfNflHjEU2ve0sN1ZOAGP3/0lqj/PjiCmZatRXLg=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      dash
    ];

    doCheck = false;
  };

  vaderSentiment = python3.pkgs.buildPythonPackage rec {
    pname = "vaderSentiment";
    version = "3.3.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-XXwG4Cf8i5kjjtsNU9lwz5cGbvl2VACYkLg3A4SWMvk=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      requests
    ];
  };

  valinvest = python3.pkgs.buildPythonPackage rec {
    pname = "valinvest";
    version = "0.0.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-lhSq+AGeAVwg6kiGft6KbqEOHGQQ54cxQGbXsuWut9w=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      requests
      pandas
    ];

    doCheck = false;
  };

  voila = python3.pkgs.buildPythonPackage rec {
    pname = "voila";
    version = "0.4.0";

    format = "pyproject";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-XJH7lpv/o/wohG2KPuroBNcVd/9J8sq2tmOtMlrmmtA=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      hatchling
      hatch-jupyter-builder
    ];
  };

  hatch-jupyter-builder = python3.pkgs.buildPythonPackage rec {
    pname = "hatch-jupyter-builder";
    version = "0.8.2";

    format = "pyproject";

    src = fetchFromGitHub {
      owner = "jupyterlab";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-Ns5jrVfTAA7NuvUok3/13nIpXSSVZ6WRkgHyTuxkSKA=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      hatchling
    ];
  };
in
python3.pkgs.buildPythonApplication rec {
  pname = "openbbterminal";
  version = "2.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OpenBB-finance";
    repo = "OpenBBTerminal";
    rev = "v${version}";
    sha256 = "0m1lmfz5nhvg483ldrmlrjhwaf284c0c0pxf0fb0sfx2dnjjj3ib"; # odoo
  };

  propagatedBuildInputs = with python3.pkgs; [
    "ruamel.yaml"
    FundamentalAnalysis
    GitPython
    jinja2
    pygments
    quandl
    riskfolio-lib
    alpha-vantage
    ascii-magic
    beautifulsoup4
    bt
    ccxt
    charset-normalizer
    degiro-connector
    detecta
    dnspython
    docstring-parser
    feedparser
    financedatabase
    finnhub-python
    finviz
    finvizfinance
    fred
    fredapi
    grpcio
    holidays
    html5lib
    investiny
    investpy
    ipyflex
    ipympl
    ipython
    ipywidgets
    iso8601
    jedi-language-server
    jsonschema
    jupyterlab
    jupyterlab-code-formatter
    jupyterlab-lsp
    jupyterlab-widgets
    linearmodels
    matplotlib
    mplfinance
    numpy
    oandapyV20
    openpyxl
    packaging
    pandas
    pandas-market-calendars
    pandas-ta
    papermill
    plotly
    praw
    prompt-toolkit
    protobuf
    psaw
    pyEX
    pyally
    pycoingecko
    pyinstaller
    pyrsistent
    pythclient
    python-binance
    python-coinmarketcap
    python-dotenv
    python-i18n
    pytorch-lightning
    pytrends
    rapidfuzz
    requests
    rich
    robin-stocks
    scipy
    screeninfo
    seaborn
    sentiment-investor
    setuptools
    squarify
    statsmodels
    stocksera
    streamlit
    thepassiveinvestor
    tokenterminal
    torch
    tradingview-ta
    u8darts
    vaderSentiment
    valinvest
    voila
    watchdog
    yfinance
  ];

  meta = with lib; {
    description = "Investment Research for Everyone, Anywhere";
    homepage = "https://www.openbb.co/";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

