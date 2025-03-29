{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  nixosTests,
  bash-completion,
  glib,
  polkit,
  pkg-config,
  gettext,
  gusb,
  lcms2,
  sqlite,
  udev,
  systemd,
  enableSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  dbus,
  gobject-introspection,
  argyllcms,
  meson,
  mesonEmulatorHook,
  ninja,
  vala,
  libgudev,
  wrapGAppsNoGuiHook,
  shared-mime-info,
  sane-backends,
  docbook_xsl,
  docbook_xsl_ns,
  docbook_xml_dtd_412,
  gtk-doc,
  libxslt,
  enableDaemon ? true,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "colord";
  version = "1.4.7";

  outputs = [
    "out"
    "dev"
    "devdoc"
    "man"
    "installedTests"
  ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "colord";
    tag = finalAttrs.version;
    hash = "sha256-/lAj8T2V23V6F8IhNNeJAq5BDWCeaMaxVd2igZP6oMo=";
  };

  patches = [
    # Put installed tests into its own output
    ./installed-tests-path.patch
    (fetchpatch {
      # Fix writing to the database with ProtectSystem=strict, can be dropped on 1.4.8
      url = "https://github.com/hughsie/colord/commit/08a32b2379fb5582f4312e59bf51a2823df56276.patch?full_index=1";
      hash = "sha256-E8EXgvyd9jMXhQOO97ZOgv3oCTWcrbtS8IR0yQNyhyo=";
    })
    # Fix USB scanners not working with RestrictAddressFamilies, can be dropped on 1.4.8
    (fetchpatch {
      url = "https://github.com/hughsie/colord/commit/9283abd9c00468edb94d2a06d6fa3681cae2700d.patch?full_index=1";
      hash = "sha256-hDA4bTuTJJxmSnmPUkVnYl2FYLoGFEBAeSDhVyr+Nhw=";
    })
  ];

  postPatch = ''
    for file in data/tests/meson.build lib/colord/cd-test-shared.c lib/colord/meson.build; do
        substituteInPlace $file --subst-var-by installed_tests_dir "$installedTests"
    done
  '';

  mesonFlags = [
    "--localstatedir=/var"
    "-Dinstalled_tests=true"
    "-Dlibcolordcompat=true"
    "-Dsane=true"
    "-Dvapi=true"
    "-Ddaemon=${lib.boolToString enableDaemon}"
    "-Ddaemon_user=colord"
    (lib.mesonBool "systemd" enableSystemd)

    # The presence of the "udev" pkg-config module (as opposed to "libudev")
    # indicates whether rules are supported.
    (lib.mesonBool "udev_rules" (lib.elem "udev" udev.meta.pkgConfigModules))
  ];

  nativeBuildInputs =
    [
      docbook_xml_dtd_412
      docbook_xsl
      docbook_xsl_ns
      gettext
      gobject-introspection
      gtk-doc
      libxslt
      meson
      ninja
      pkg-config
      shared-mime-info
      vala
      wrapGAppsNoGuiHook
    ]
    ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      mesonEmulatorHook
    ];

  buildInputs =
    [
      argyllcms
      bash-completion
      dbus
      glib
      gusb
      lcms2
      libgudev
      sane-backends
      sqlite
      udev
    ]
    ++ lib.optionals enableSystemd [
      systemd
    ]
    ++ lib.optionals enableDaemon [
      polkit
    ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
  PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "${placeholder "out"}/lib/systemd/user";
  PKG_CONFIG_SYSTEMD_TMPFILESDIR = "${placeholder "out"}/lib/tmpfiles.d";
  PKG_CONFIG_BASH_COMPLETION_COMPLETIONSDIR = "${placeholder "out"}/share/bash-completion/completions";
  PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.colord;
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "System service to manage, install and generate color profiles to accurately color manage input and output devices";
    homepage = "https://www.freedesktop.org/software/colord/";
    license = licenses.lgpl2Plus;
    maintainers = [ maintainers.marcweber ] ++ teams.freedesktop.members;
    platforms = platforms.linux;
  };
})
