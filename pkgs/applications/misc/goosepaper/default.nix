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
  version = "unstable-2022-02-07";

  src = fetchFromGitHub {
    owner = "j6k4m8";
    repo = pname;
    rev = "b135ca43b757cb5b231586787be552ec7519d28a";
    sha256 = "sha256-6qp5lscy45obnR00TMBdSKsl5ITRxuphF6bdg5ebUKA=";
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
