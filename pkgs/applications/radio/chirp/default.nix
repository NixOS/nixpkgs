{ lib
, fetchFromGitHub
, glib
, gsettings-desktop-schemas
, python3
, unstableGitUpdater
, wrapGAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "chirp";
  version = "unstable-2023-06-02";

  src = fetchFromGitHub {
    owner = "kk7ds";
    repo = "chirp";
    rev = "72789c3652c332dc68ba694f8f8f005913fe5c95";
    hash = "sha256-WQwCX7h9BFLdYOBVVntxQ6g4t3j7QLfNmlHVLzlRh7U=";
  };
  buildInputs = [
    glib
    gsettings-desktop-schemas
  ];
  nativeBuildInputs = [
    wrapGAppsHook
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
    branch = "py3";
  };

  meta = with lib; {
    description = "A free, open-source tool for programming your amateur radio";
    homepage = "https://chirp.danplanet.com/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
