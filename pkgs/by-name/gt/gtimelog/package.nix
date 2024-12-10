{
  lib,
  fetchFromGitHub,
  python3Packages,
  wrapGAppsHook3,
  glibcLocales,
  gobject-introspection,
  gtk3,
  libsoup_3,
  libsecret,
}:

python3Packages.buildPythonApplication rec {
  pname = "gtimelog";
  version = "unstable-2023-10-05";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "ba606cbe8eef0e3dc098c6ab3bcbe381bf7ef410";
    hash = "sha256-+iBHfbUJtAtI/vcHj0Y8f9OxAp1SnhQyMqedVzSYPZQ=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];
  buildInputs = [
    glibcLocales
    gtk3
    libsoup_3
    libsecret
  ];
  propagatedBuildInputs = with python3Packages; [
    pygobject3
  ];
  checkInputs = with python3Packages; [
    freezegun
  ];

  checkPhase = ''
    patchShebangs ./runtests
    ./runtests
  '';

  pythonImportsCheck = [ "gtimelog" ];

  dontWrapGApps = true;

  # Arguments to be passed to `makeWrapper`, only used by buildPython*
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstall = ''
    install -Dm644 gtimelog.desktop $out/share/applications/gtimelog.desktop
    install -Dm644 src/gtimelog/gtimelog.png $out/share/icons/hicolor/48x48/apps/gtimelog.png
    install -Dm644 src/gtimelog/gtimelog-large.png $out/share/icons/hicolor/256x256/apps/gtimelog.png
  '';

  meta = with lib; {
    description = "A time tracking app";
    mainProgram = "gtimelog";
    longDescription = ''
      GTimeLog is a small time tracking application for GNOME.
      It's main goal is to be as unintrusive as possible.

      To run gtimelog successfully on a system that does not have full GNOME
      installed, the following NixOS options should be set:
      - programs.dconf.enable = true;
    '';
    homepage = "https://gtimelog.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ oxzi ];
  };
}
