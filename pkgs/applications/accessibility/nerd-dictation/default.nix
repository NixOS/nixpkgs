{ fetchFromGitHub
, substituteAll
, lib
, stdenv
, python3
, pulseaudio
, xdotool
, ydotool
, unstableGitUpdater
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nerd-dictation";
  version = "unstable-2023-04-19";

  src = fetchFromGitHub {
    owner = "ideasman42";
    repo = "nerd-dictation";
    rev = "96ef5ce64d37c7ebe9a704315665096ac4a697d4";
    hash = "sha256-w8EG6x0ieb9PwetNHkRHDE1FjVEH7QvjxPasaQwOAkg=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      parec = "${pulseaudio}/bin/parec";
      xdotool = "${xdotool}/bin/xdotool";
      ydotool = "${ydotool}/bin/ydotool";
    })
  ];

  propagatedBuildInputs = with python3.pkgs; [
    vosk-python
  ];

  postPatch = ''
    cd package/python
  '';

  # No tests.
  doCheck = false;

  # Broken for some reason.
  dontUsePythonCatchConflicts = true;

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    description = "Simple, hackable offline speech to text";
    homepage = "https://github.com/ideasman42/nerd-dictation";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
