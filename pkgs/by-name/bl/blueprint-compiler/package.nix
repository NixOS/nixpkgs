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
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "blueprint-compiler";
  version = "0.18.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "blueprint-compiler";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3vAFkP/psM/IsFtzVOIVSU77Z+RV4d3N70U7ggrDqfo=";
  };

  postPatch = ''
    patchShebangs docs/collect-sections.py
  '';

  nativeBuildInputs = [
    meson
    ninja
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

  passthru.tests = {
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

  meta = with lib; {
    description = "Markup language for GTK user interface files";
    mainProgram = "blueprint-compiler";
    homepage = "https://gitlab.gnome.org/GNOME/blueprint-compiler";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [
      benediktbroich
      ranfdev
    ];
    platforms = platforms.unix;
  };
})
