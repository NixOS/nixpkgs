{ lib
, python3Packages
, rtmpdump
, ffmpeg
}:

python3Packages.buildPythonApplication rec {
  pname = "streamlink";
  version = "2.4.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "e95588e222d1a7bd51e3171cd4bce84fd6f646418537aff37993d40f597810af";
  };

  checkInputs = with python3Packages; [
    pytestCheckHook
    mock
    requests-mock
    freezegun
  ];

  propagatedBuildInputs = (with python3Packages; [
    pycryptodome
    requests
    iso-639
    iso3166
    websocket-client
    isodate
    lxml
  ]) ++ [
    rtmpdump
    ffmpeg
  ];

  # note that upstream currently uses requests 2.25.1 in Windows builds
  postPatch = ''
    substituteInPlace setup.py \
      --replace 'requests>=2.26.0,<3.0' 'requests'
  '';

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
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ dezgeg zraexy DeeUnderscore ];
  };
}
