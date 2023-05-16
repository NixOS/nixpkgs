{ lib
, python3Packages
<<<<<<< HEAD
, fetchPypi
, ffmpeg
=======
, ffmpeg
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python3Packages.buildPythonApplication rec {
  pname = "streamlink";
<<<<<<< HEAD
  version = "6.1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FwsgJ9TYBzCHxYlBwxrsOEy/mQH8tAH4JOkZrjh8Q4U=";
=======
  version = "5.3.0";
  format = "pyproject";

  src = python3Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-+9MSSzPYZ8gwOeQLehR41SklfdcUn8Pa6TI//lh9twE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    mock
    requests-mock
    freezegun
    pytest-asyncio
<<<<<<< HEAD
    pytest-trio
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeBuildInputs = with python3Packages; [
    versioningit
  ];

  propagatedBuildInputs = (with python3Packages; [
<<<<<<< HEAD
    certifi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    isodate
    lxml
    pycountry
    pycryptodome
    pysocks
    requests
<<<<<<< HEAD
    trio
    trio-websocket
    typing-extensions
    urllib3
    websocket-client
=======
    websocket-client
    urllib3
    certifi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ]) ++ [
    ffmpeg
  ];

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://github.com/streamlink/streamlink/raw/${version}/CHANGELOG.md";
    description = "CLI for extracting streams from various websites to video player of your choosing";
    homepage = "https://streamlink.github.io/";
=======
    homepage = "https://streamlink.github.io/";
    description = "CLI for extracting streams from various websites to video player of your choosing";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    longDescription = ''
      Streamlink is a CLI utility that pipes videos from online
      streaming services to a variety of video players such as VLC, or
      alternatively, a browser.

      Streamlink is a fork of the livestreamer project.
    '';
<<<<<<< HEAD
    license = licenses.bsd2;
    mainProgram = "streamlink";
=======
    changelog = "https://github.com/streamlink/streamlink/raw/${version}/CHANGELOG.md";
    license = licenses.bsd2;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ dezgeg zraexy DeeUnderscore ];
  };
}
