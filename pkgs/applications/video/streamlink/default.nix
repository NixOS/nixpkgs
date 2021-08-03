{ lib
, python3
, fetchFromGitHub
, rtmpdump
, ffmpeg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "streamlink";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "streamlink";
    repo = "streamlink";
    rev = version;
    sha256 = "sha256-lsurDFvVHn1rxR3bgG7BY512ISavpja36/UaKXauf+g=";
  };

  checkInputs = with python3.pkgs; [
    pytestCheckHook
    mock
    requests-mock
    freezegun
  ];

  propagatedBuildInputs = (with python3.pkgs; [
    pycryptodome
    requests
    iso-639
    iso3166
    websocket-client
    isodate
  ]) ++ [
    rtmpdump
    ffmpeg
  ];

  # note that upstream currently uses requests 2.25.1 in Windows builds
  postPatch = ''
    substituteInPlace setup.py \
      --replace 'requests>=2.26.0,<3.0' 'requests>=2.25.1,<3.0'
  '';

  meta = with lib; {
    homepage = "https://github.com/streamlink/streamlink";
    description = "CLI for extracting streams from various websites to video player of your choosing";
    longDescription = ''
      Streamlink is a CLI utility that pipes videos from online
      streaming services to a variety of video players such as VLC, or
      alternatively, a browser.

      Streamlink is a fork of the livestreamer project.
    '';
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ dezgeg zraexy DeeUnderscore ];
  };
}
