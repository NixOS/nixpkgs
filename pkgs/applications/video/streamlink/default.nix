{ lib
, python3Packages
, ffmpeg
, fetchpatch
}:

python3Packages.buildPythonApplication rec {
  pname = "streamlink";
  version = "3.0.3";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-oEK9p6OuqGSm2JdgfnJ+N0sJtRq6wCoVCGcU0GNEMLI=";
  };

  checkInputs = with python3Packages; [
    pytestCheckHook
    mock
    requests-mock
    freezegun
  ];

  propagatedBuildInputs = (with python3Packages; [
    isodate
    lxml
    pycountry
    pycryptodome
    pysocks
    requests
    websocket-client
  ]) ++ [
    ffmpeg
  ];

  postPatch = ''
    substituteInPlace setup.cfg --replace 'lxml >=4.6.4,<5.0' 'lxml'
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
