{
  dbus,
  fetchFromGitLab,
  gobject-introspection,
  lib,
  libadwaita,
  meson,
  ninja,
  python3,
  runCommand,
  stdenv,
  testers,
  wrapGAppsNoGuiHook,
  xvfb-run,
  gnome,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "blueprint-compiler";
  version = "0.22.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "blueprint-compiler";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DRpPUfiufwK2c2RW01IYIX6tgVyxfFl5hnv5F8+9aD4=";
  };

  postPatch = ''
    patchShebangs docs/collect-sections.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$out/${python3.sitePackages}"
      --prefix PYTHONPATH : "${python3.pkgs.makePythonPath [ python3.pkgs.pygobject3 ]}"
    )
  '';

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    python3
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    libadwaita
    (python3.withPackages (
      ps: with ps; [
        pygobject3
      ]
    ))
  ];

  propagatedBuildInputs = [
    # For setup hook, so that the compiler can find typelib files
    gobject-introspection
  ];

  nativeCheckInputs = [
    dbus
    xvfb-run
  ];

  # requires xvfb-run
  doCheck = !stdenv.hostPlatform.isDarwin && false; # tests time out

  checkPhase = ''
    runHook preCheck

    xvfb-run dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      meson test --no-rebuild --print-errorlogs

    runHook postCheck
  '';

  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
      # regression test that `blueprint-compiler` can be used in a standalone
      # context outside of nix builds, and doesn't rely on the setup hooks of
      # its propagated inputs for basic functionality.
      # see https://github.com/NixOS/nixpkgs/pull/400415
      standalone = runCommand "blueprint-compiler-test-standalone" { } ''
        ${lib.getExe finalAttrs.finalPackage} --help && touch $out
      '';
    };
    updateScript = gnome.updateScript {
      packageName = "blueprint-compiler";
    };
  };

  strictDeps = true;

  meta = {
    description = "Markup language for GTK user interface files";
    mainProgram = "blueprint-compiler";
    homepage = "https://gitlab.gnome.org/GNOME/blueprint-compiler";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      benediktbroich
      ranfdev
    ];
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.unix;
  };
})
