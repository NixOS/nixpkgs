{
  lib,
  fetchFromGitHub,
  writeShellScript,
  glib,
  gsettings-desktop-schemas,
  python3,
  unstableGitUpdater,
  wrapGAppsHook3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "chirp";
  version = "0.4.0-unstable-2024-10-03";

  src = fetchFromGitHub {
    owner = "kk7ds";
    repo = "chirp";
    rev = "387d8f63535140779864e8973fbde0bad17f8512";
    hash = "sha256-kJ2Cr2ks901GUVFscyCInsTSTM7g42NRYYxjTZsh1Lw=";
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
    maintainers = with maintainers; [
      emantor
      wrmilling
    ];
    platforms = platforms.linux;
  };
}
