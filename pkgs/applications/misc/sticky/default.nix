{ stdenv
, lib
, fetchFromGitHub
, gobject-introspection
, meson
, ninja
, python3
, wrapGAppsHook3
, cinnamon
, glib
, gspell
, gtk3
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "sticky";
  version = "1.20";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-HzTXaJgDu72pWM0mGNNBy2yFB0u0rqATFK9JzyOw8oE=";
  };

  postPatch = ''
    sed -i -e "s|/usr/lib|$out/lib|" usr/bin/sticky
    sed -i -e "s|/usr/share|$out/share|" usr/lib/sticky/*.py
  '';

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    python3.pkgs.wrapPython
    wrapGAppsHook3
  ];

  buildInputs = [
    cinnamon.xapp
    glib
    gspell
    gtk3
    python3 # for patchShebangs
  ];

  pythonPath = with python3.pkgs; [
    pygobject3
    xapp
  ];

  dontWrapGApps = true;

  preFixup = ''
    buildPythonPath "$out $pythonPath"

    wrapProgram $out/bin/sticky \
      --prefix PYTHONPATH : "$program_PYTHONPATH" \
      ''${gappsWrapperArgs[@]}
  '';

  passthru = {
    updateScript = gitUpdater {
      ignoredVersions = ''master.*'';
    };
  };

  meta = with lib; {
    description = "Sticky notes app for the linux desktop";
    mainProgram = "sticky";
    homepage = "https://github.com/linuxmint/sticky";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ linsui bobby285271 ];
  };
}
