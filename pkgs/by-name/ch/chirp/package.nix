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
  version = "0.4.0-unstable-2024-09-28";

  src = fetchFromGitHub {
    owner = "kk7ds";
    repo = "chirp";
    rev = "c09d51c5b92995de266ef4d7f285b8d110c0bdc7";
    hash = "sha256-ErIAqXexgKjpbnubekX9Gy0qAkUDhNil8PtEOcxYVdk=";
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
