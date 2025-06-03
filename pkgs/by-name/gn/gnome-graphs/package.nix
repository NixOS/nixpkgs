{
  lib,
  python3Packages,
  fetchFromGitLab,
  meson,
  ninja,
  vala,
  pkg-config,
  gobject-introspection,
  blueprint-compiler,
  itstool,
  wrapGAppsHook4,
  desktop-file-utils,
  shared-mime-info,
  libadwaita,
  libgee,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "gnome-graphs";
  version = "1.8.4";
  pyproject = false;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Graphs";
    rev = "v${version}";
    hash = "sha256-up4Hv2gndekDQzEnf7kkskDyRGJ/mqEji7dsuLgnUVI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    gobject-introspection
    blueprint-compiler
    itstool
    wrapGAppsHook4
    desktop-file-utils
    shared-mime-info
  ];

  buildInputs = [
    libadwaita
    libgee
  ];

  dependencies = with python3Packages; [
    pygobject3
    numpy
    numexpr
    sympy
    scipy
    matplotlib
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix LD_LIBRARY_PATH : $out/lib
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Simple, yet powerful tool that allows you to plot and manipulate your data with ease";
    homepage = "https://apps.gnome.org/Graphs";
    license = licenses.gpl3Plus;
    mainProgram = "graphs";
    teams = [ lib.teams.gnome-circle ];
    platforms = platforms.linux; # locale.bindtextdomain only available on linux
  };
}
