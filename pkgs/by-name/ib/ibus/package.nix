{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  mesonEmulatorHook,
  ninja,
  bash,
  gettext,
  pkg-config,
  vala,
  wrapGAppsHook3,
  dbus,
  systemdLibs,
  dconf ? null,
  glib,
  gdk-pixbuf,
  gobject-introspection,
  gtk3,
  gtk4,
  libdbusmenu-gtk3,
  isocodes,
  cldr-annotations,
  unicode-character-database,
  unicode-emoji,
  python3,
  json-glib,
  libnotify ? null,
  enableUI ? !libOnly,
  withWayland ? !libOnly,
  withSystemd ? !libOnly && lib.meta.availableOn stdenv.hostPlatform systemdLibs,
  libxkbcommon,
  wayland,
  wayland-protocols,
  wayland-scanner,
  runtimeShell,
  nixosTests,
  versionCheckHook,
  nix-update-script,
  libx11,
  libOnly ? false,
}:

let
  python3Runtime = python3.withPackages (ps: with ps; [ pygobject3 ]);
in

stdenv.mkDerivation (finalAttrs: {
  pname = "ibus";
  version = "1.5.35";

  src = fetchFromGitHub {
    owner = "ibus";
    repo = "ibus";
    tag = finalAttrs.version;
    hash = "sha256-Wd4z3NMwh9kEu18aLbdF4vGg2gOqBJbpURbinFq6fnM=";
  };

  patches = [
    # Nix-specific sandbox workaround: generating schema defaults does not need
    # a session bus, so avoid the unnecessary dbus-launch invocation.
    ./build-without-dbus-launch.patch

    # Fix configuration summaries when optional bindings are unavailable.
    # https://github.com/ibus/ibus/pull/2989
    (fetchpatch {
      name = "ibus-initialize-optional-dependency-variables.patch";
      url = "https://github.com/ibus/ibus/commit/c289671609d114453a710a12621a7644b120a916.patch";
      hash = "sha256-+TQ9MW4O8GQ3QAZETPhG4uf17ryFA1QRmA9kPK5RjzM=";
    })

    # Recognize libX11's Nix-store compose files as system compose files.
    ./system-compose-path.patch

    # Make the test prefix configurable for Nix's separate installedTests output,
    # keeping test files and their embedded paths out of the runtime output.
    ./installed-tests-paths.patch
  ];

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals (!libOnly) [
    "installedTests"
  ];

  postPatch = ''
    # Maintainer does not want to create separate tarballs for final release candidate and release versions,
    # so we need to set `IBUS_RELEASED` to `1` in `meson.config`. Otherwise, anyone running `ibus version` gets
    # a version with an inaccurate `-rcX` suffix.
    # https://github.com/ibus/ibus/issues/2584
    substituteInPlace meson.config --replace-fail "IBUS_RELEASED=0" "IBUS_RELEASED=1"

    # Use Python with PyGObject at runtime, independently of the build Python.
    substituteInPlace setup/ibus-setup.in \
      --replace-fail 'exec ''${PYTHON:-@PYTHON@}' 'exec ${python3Runtime.interpreter}'

    patchShebangs --build data/dconf/make-dconf-override-db.sh src/get_system_langs.py
    # xkb-latin-layouts needs echo and glib's gsettings command to enumerate layouts.
    substituteInPlace src/tests/xkb-latin-layouts \
      --replace-fail '/usr/bin/echo' 'echo' \
      --replace-fail 'gsettings get' '${lib.getExe' glib "gsettings"} get'
    substituteInPlace \
      bus/services/org.freedesktop.IBus.session.GNOME.service.in \
      bus/services/org.freedesktop.IBus.session.generic.service.in \
      --replace-fail "ExecStart=sh" "ExecStart=${runtimeShell}"

    # These manual AppIndicator queries must use the host pkg-config, like dependency().
    substituteInPlace meson.build \
      --replace-fail "run_command('pkg-config'," "run_command('${stdenv.cc.targetPrefix}pkg-config',"
  '';

  mesonFlags = [
    (lib.mesonBool "gtk-doc" false)
    (lib.mesonBool "memconf" false)
    (lib.mesonOption "x11-localedata-dir" "${libx11.out}/share/X11/locale")
    (lib.mesonEnable "gtk2" false)
    (lib.mesonOption "python-overrides-dir" "${placeholder "out"}/${python3.sitePackages}/gi/overrides")
    (lib.mesonEnable "dconf" (!libOnly && dconf != null))
    (lib.mesonBool "libnotify" (!libOnly && libnotify != null))
    (lib.mesonEnable "wayland" withWayland)
    (lib.mesonEnable "systemd-services" withSystemd)
    (lib.mesonBool "ui" enableUI)
    (lib.mesonBool "gtk3" (!libOnly))
    (lib.mesonBool "gtk4" (!libOnly))
    (lib.mesonEnable "xim" (!libOnly))
    (lib.mesonBool "appindicator" (!libOnly))
    (lib.mesonBool "tests" (!libOnly))
    (lib.mesonBool "install-tests" (!libOnly))
    (lib.mesonBool "emoji-dict" (!libOnly))
    (lib.mesonBool "unicode-dict" (!libOnly))
  ]
  ++ lib.optionals (!libOnly) [
    (lib.mesonOption "installed-tests-prefix" (placeholder "installedTests"))
    (lib.mesonOption "unicode-emoji-dir" "${unicode-emoji}/share/unicode/emoji")
    (lib.mesonOption "emoji-annotation-dir" "${cldr-annotations}/share/unicode/cldr/common/annotations")
    (lib.mesonOption "ucd-dir" "${unicode-character-database}/share/unicode")
  ];

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    python3
    glib
    vala
    gobject-introspection
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    # Meson runs the compose, emoji, and Unicode generators built for the host.
    mesonEmulatorHook
  ]
  ++ lib.optionals (!libOnly) [
    wrapGAppsHook3
  ]
  ++ lib.optionals withWayland [
    wayland-scanner
  ];

  propagatedBuildInputs = [
    glib
  ];

  buildInputs = [
    bash
    dbus
    isocodes
    json-glib
    libx11
  ]
  ++ lib.optionals withSystemd [
    systemdLibs
  ]
  ++ lib.optionals (!libOnly && dconf != null) [
    dconf
  ]
  ++ lib.optionals (!libOnly) [
    gtk3
    gtk4
    gdk-pixbuf
    libdbusmenu-gtk3
    libnotify
    python3.pkgs.pygobject3 # for pygobject overrides
  ]
  ++ lib.optionals withWayland [
    libxkbcommon
    wayland
    wayland-protocols
  ];
  strictDeps = true;
  __structuredAttrs = true;

  doCheck = false; # requires X11 daemon

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  versionCheckProgram = "${placeholder "out"}/bin/ibus";

  postInstall = lib.optionalString (!libOnly && dconf != null) ''
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  wrapGAppsInOutputs = [ "out" ] ++ lib.optionals (!libOnly) [ "installedTests" ];

  passthru = {
    tests = lib.optionalAttrs (!libOnly) {
      installed-tests = nixosTests.installed-tests.ibus;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/ibus/ibus/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/ibus/ibus";
    description = "Intelligent Input Bus, input method framework";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    mainProgram = "ibus";
    maintainers = [ ];
  };
})
