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
<<<<<<< HEAD
  version = "unstable-2023-06-02";
=======
  version = "unstable-2023-03-15";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kk7ds";
    repo = "chirp";
<<<<<<< HEAD
    rev = "72789c3652c332dc68ba694f8f8f005913fe5c95";
    hash = "sha256-WQwCX7h9BFLdYOBVVntxQ6g4t3j7QLfNmlHVLzlRh7U=";
=======
    rev = "33402b7c545c5a92b7042369867e7eb75ef32a59";
    hash = "sha256-duSEpd2GBBskoKNFos5X9wFtsjRct1918VhZd1T2rvU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    wxPython_4_2
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
