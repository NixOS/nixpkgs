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
  sqlite,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gnome-graphs";
  version = "2.0.3";
  pyproject = false;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Graphs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Fx2/xjr8EVIXmuPzcSVGx5eEPmBffHEqeZUvsN2+prs=";
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
    sqlite
  ];

  dependencies = with python3Packages; [
    pygobject3
    gio-pyio
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

  meta = {
    description = "Simple, yet powerful tool that allows you to plot and manipulate your data with ease";
    homepage = "https://apps.gnome.org/Graphs";
    license = lib.licenses.gpl3Plus;
    mainProgram = "graphs";
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.linux; # locale.bindtextdomain only available on linux
  };
})
