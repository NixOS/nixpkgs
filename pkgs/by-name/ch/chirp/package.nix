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
  version = "0.4.0-unstable-2024-09-05";

  src = fetchFromGitHub {
    owner = "kk7ds";
    repo = "chirp";
    rev = "f9f5afa33388d3b05af75b40195b6a45a19df9a2";
    hash = "sha256-wpUtSXSmT9SgwKMYeto7jJGK7ZEFQ/t37wWjUMB86YQ=";
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
