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

let
  libadwaita' = libadwaita.overrideAttrs (oldAttrs: {
    version = "1.6.2-unstable-2025-01-02";
    src = oldAttrs.src.override {
      rev = "f5f0e7ce69405846a8f8bdad11cef2e2a7e99010";
      hash = "sha256-n5RbGHtt2g627T/Tg8m3PjYIl9wfYTIcrplq1pdKAXk=";
    };

    # `test-application-window` is flaky on aarch64-linux
    doCheck = false;
  });
in

python3Packages.buildPythonApplication rec {
  pname = "refine";
  version = "0.4.2";
  pyproject = false; # uses meson

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "TheEvilSkeleton";
    repo = "Refine";
    tag = version;
    hash = "sha256-5oXLcmj0ZWYaCP93S+tSTqFn+XnrUkE/VwiA3ufvSQ0=";
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
    libadwaita'
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
