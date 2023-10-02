{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "yewtube";
  version = "2.10.5";

  src = fetchFromGitHub {
    owner = "mps-youtube";
    repo = "yewtube";
    rev = "refs/tags/v${version}";
    hash = "sha256-a7ySRHSRHmQePaVV7HnCk8QsiAQfN4nCVRdamPMUHGo=";
  };

  postPatch = ''
    # Don't try to detect the version at runtime with pip
    substituteInPlace mps_youtube/__init__.py \
      --replace "from pip._vendor import pkg_resources" "" \
      --replace "__version__ =" "__version__ = '${version}' #"
  '';

  propagatedBuildInputs = with python3Packages; [
    pyperclip
    requests
    youtube-search-python
    yt-dlp
    pylast
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
    dbus-python
    pygobject3
  ];

  preCheck = ''
    export XDG_CONFIG_HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "mps_youtube" ];

  meta = with lib; {
    description = "Terminal based YouTube player and downloader, forked from mps-youtube";
    homepage = "https://github.com/mps-youtube/yewtube";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz koral ];
  };
}
