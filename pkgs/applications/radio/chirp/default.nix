{ lib
, fetchFromGitHub
, writeShellScript
, glib
, gsettings-desktop-schemas
, python3
, unstableGitUpdater
, wrapGAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "chirp";
  version = "0.4.0-unstable-2024-02-08";

  src = fetchFromGitHub {
    owner = "kk7ds";
    repo = "chirp";
    rev = "902043a937ee3611744f2a4e35cd902c7b0a8d0b";
    hash = "sha256-oDUtR1xD73rfBRKkbE1f68siO/4oxoLxw16w1qa9fEo=";
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
    tagConverter = writeShellScript "chirp-tag-converter.sh" ''
      sed -e 's/^release_//g' -e 's/_/./g'
    '';
  };

  meta = with lib; {
    description = "A free, open-source tool for programming your amateur radio";
    homepage = "https://chirp.danplanet.com/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.emantor ];
    platforms = platforms.linux;
  };
}
