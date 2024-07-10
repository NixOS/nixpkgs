{ lib
, fetchFromGitHub
, writeShellScript
, glib
, gsettings-desktop-schemas
, python3
, unstableGitUpdater
, wrapGAppsHook3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "chirp";
  version = "0.4.0-unstable-2024-05-24";

  src = fetchFromGitHub {
    owner = "kk7ds";
    repo = "chirp";
    rev = "e17c021ba4fc39eea8a2a1de37ef04a0d1253090";
    hash = "sha256-YvIRo7g9fxnlf8og5CM2JLf8DeADVkcHdvb4ppS1veE=";
  };
  buildInputs = [
    glib
    gsettings-desktop-schemas
  ];
  nativeBuildInputs = [
    wrapGAppsHook3
  ];
  propagatedBuildInputs = with python3.pkgs; [
    future
    pyserial
    requests
    six
    wxpython
    yattag
  ];

  # "running build_ext" fails with no output
  doCheck = false;

  passthru.updateScript = unstableGitUpdater {
    tagConverter = writeShellScript "chirp-tag-converter.sh" ''
      sed -e 's/^release_//g' -e 's/_/./g'
    '';
  };

  meta = with lib; {
    description = "Free, open-source tool for programming your amateur radio";
    homepage = "https://chirp.danplanet.com/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.emantor ];
    platforms = platforms.linux;
  };
}
