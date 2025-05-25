{
  lib,
  fetchFromGitLab,
  nix-update-script,
  blueprint-compiler,
  desktop-file-utils,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  python3,
  libxml2,
  python3Packages,
  libportal,
  libportal-gtk4,
  appstream,
  gtk4,
  glib,
}:

python3Packages.buildPythonApplication rec {
  pname = "refine";
  version = "0.5.9";
  pyproject = false; # uses meson

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "TheEvilSkeleton";
    repo = "Refine";
    tag = version;
    hash = "sha256-jX2U6YZCvB8IxUHoByO4egqV40C/L/O8z7AIEYYHBRY=";
  };

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    glib # For `glib-compile-schemas`
    gtk4 # For `gtk-update-icon-cache`
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    python3
    desktop-file-utils
  ];

  buildInputs = [
    libxml2
    libadwaita
  ];

  dependencies =
    [
      libportal
      libportal-gtk4
    ]
    ++ (with python3Packages; [
      pygobject3
    ]);

  strictDeps = true;

  mesonFlags = [ (lib.mesonBool "network_tests" false) ];

  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  # NOTE: `postCheck` is intentionally not used here, as the entire checkPhase
  # is skipped by `buildPythonApplication`
  # https://github.com/NixOS/nixpkgs/blob/9d4343b7b27a3e6f08fc22ead568233ff24bbbde/pkgs/development/interpreters/python/mk-python-derivation.nix#L296
  postInstallCheck = ''
    mesonCheckPhase
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tweak various aspects of GNOME";
    homepage = "https://gitlab.gnome.org/TheEvilSkeleton/Refine";
    mainProgram = "refine";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
