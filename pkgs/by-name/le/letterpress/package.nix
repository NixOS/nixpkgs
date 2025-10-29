{
  lib,
  fetchFromGitLab,
  wrapGAppsHook4,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  gettext,
  gobject-introspection,
  jp2a,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  python3Packages,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "letterpress";
  version = "2.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "letterpress";
    rev = version;
    hash = "sha256-cqLodI6UjdLCKLGGcSIbXu1+LOcq2DE00V+lVS7OBMg=";
  };

  runtimeDeps = [
    jp2a
  ];

  buildInputs = [
    libadwaita
  ];

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    desktop-file-utils
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  dependencies = with python3Packages; [
    pillow
    pygobject3
  ];

  pyproject = false; # built by meson
  dontWrapGApps = true; # prevent double wrapping

  preFixup = ''
    makeWrapperArgs+=(''${gappsWrapperArgs[@]} --prefix PATH : ${lib.makeBinPath runtimeDeps})
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Create beautiful ASCII art";
    longDescription = ''
      Letterpress converts your images into a picture made up of ASCII characters.
      You can save the output to a file, copy it, and even change its resolution!
      High-res output can still be viewed comfortably by lowering the zoom factor.
    '';
    homepage = "https://apps.gnome.org/Letterpress/";
    changelog = "https://gitlab.gnome.org/World/Letterpress/-/releases/${version}";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.dawidd6 ];
    teams = [ teams.gnome-circle ];
    platforms = platforms.linux;
    mainProgram = "letterpress";
  };
}
