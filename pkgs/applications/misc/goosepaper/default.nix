{ lib
, fetchFromGitHub

# goosepaper
, buildPythonApplication
, lxml
, feedparser
, readability-lxml
, ebooklib
, pandas
, requests
, weasyprint
, beautifulsoup4

# rmapy fork
, buildPythonPackage
, pyaml
}:

let

  # Custom fork of "rmapi", used only in "goosepaper"
  rmapy = buildPythonPackage rec {
    pname = "rmapy";
    version = "unstable-2022-01-14";

    src = fetchFromGitHub {
      owner = "j6k4m8";
      repo = pname;
      rev = "61c2885b9c6761cbd8bd33c5f830c00444b55e3c";
      sha256 = "sha256-qrmcpKXsEVYBTDn+7eVxzRMUkhgzrfbTFH12xTv5dj0=";
    };

    postPatch = ''
      substituteInPlace setup.py \
        --replace 'pyaml==19.4.1' 'pyaml'
    '';

    propagatedBuildInputs = [
      requests
      pyaml
    ];

    pythonImportsCheck = [ "rmapy" ];

    meta = with lib; {
      description = "FORK PARTY! A unofficial python module for interacting with the Remarkable Cloud.";
      homepage = "https://github.com/j6k4m8/rmapy";
      license = licenses.mit;
    };
  };

in buildPythonApplication rec {
  pname = "goosepaper";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "j6k4m8";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RKz84yZKFy5HOYYWcPkAFdOI+/zK2Jy9BvYetTuG4cA=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace bs4 beautifulsoup4

    # Missing dependency for this provider
    sed -i '/MultiTwitterStoryProvider/d' **/*.py
  '';

  propagatedBuildInputs = [
    lxml
    feedparser
    readability-lxml
    ebooklib
    pandas
    requests
    weasyprint
    beautifulsoup4
    rmapy
    # TODO: "twint" for Twitter story provider
  ];

  doCheck = false;  # Tests want to connect to the Internet

  pythonImportsCheck = [ "goosepaper" ];

  meta = with lib; {
    description = "generate and deliver a daily newspaper to you or your remarkable tablet";
    homepage = "https://github.com/j6k4m8/goosepaper";
    license = licenses.asl20;
    maintainers = with maintainers; [ pacien ];
  };
}
