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
  version = "0.4.0-unstable-2024-08-31";

  src = fetchFromGitHub {
    owner = "kk7ds";
    repo = "chirp";
    rev = "fddaaa00e3baa3c4e854ab88ab46fd3b4ced3a62";
    hash = "sha256-KPdv8E0ZaLK49H2Q749UaLYIXdiplIKTrbkD7+KTAYg=";
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
    suds
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
    maintainers = with maintainers; [ emantor wrmilling ];
    platforms = platforms.linux;
  };
}
