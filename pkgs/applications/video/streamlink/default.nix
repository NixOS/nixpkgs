{ lib
, python3Packages
, ffmpeg
, fetchpatch
}:

python3Packages.buildPythonApplication rec {
  pname = "streamlink";
  version = "5.3.0";
  format = "pyproject";

  src = python3Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-+9MSSzPYZ8gwOeQLehR41SklfdcUn8Pa6TI//lh9twE=";
  };

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    mock
    requests-mock
    freezegun
    pytest-asyncio
  ];

  nativeBuildInputs = with python3Packages; [
    versioningit
  ];

  propagatedBuildInputs = (with python3Packages; [
    isodate
    lxml
    pycountry
    pycryptodome
    pysocks
    requests
    websocket-client
    urllib3
    certifi
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
