{ lib
, python3Packages
, fetchPypi
, ffmpeg
}:

python3Packages.buildPythonApplication rec {
  pname = "streamlink";
  version = "6.0.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BeP+YOBtTz1D//LDBMha+07yVXdgBHfM4v4aVNHzwAw=";
  };

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    mock
    requests-mock
    freezegun
    pytest-asyncio
    pytest-trio
  ];

  nativeBuildInputs = with python3Packages; [
    versioningit
  ];

  propagatedBuildInputs = (with python3Packages; [
    certifi
    isodate
    lxml
    pycountry
    pycryptodome
    pysocks
    requests
    trio
    trio-websocket
    typing-extensions
    urllib3
    websocket-client
  ]) ++ [
    ffmpeg
  ];

  meta = with lib; {
    homepage = "https://streamlink.github.io/";
    description = "CLI for extracting streams from various websites to video player of your choosing";
    longDescription = ''
      Streamlink is a CLI utility that pipes videos from online
      streaming services to a variety of video players such as VLC, or
      alternatively, a browser.

      Streamlink is a fork of the livestreamer project.
    '';
    changelog = "https://github.com/streamlink/streamlink/raw/${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dezgeg zraexy DeeUnderscore ];
  };
}
