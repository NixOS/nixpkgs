{
  lib,
  stdenv,
  pkgsCross,
  appstream,
  bison,
  bubblewrap,
  buildPackages,
  bzip2,
  coreutils,
  curl,
  dconf,
  desktop-file-utils,
  docbook-xsl-nons,
  docbook_xml_dtd_45,
  fetchurl,
  fuse3,
  gdk-pixbuf,
  gettext,
  glib,
  glib-networking,
  gobject-introspection,
  gpgme,
  gsettings-desktop-schemas,
  gtk-doc,
  gtk3,
  hicolor-icon-theme,
  json-glib,
  libarchive,
  libcap,
  librsvg,
  libseccomp,
  libxml2,
  libxslt,
  malcontent,
  meson,
  ninja,
  nix-update-script,
  nixos-icons,
  ostree,
  p11-kit,
  pkg-config,
  polkit,
  python3,
  runCommand,
  shared-mime-info,
  socat,
  replaceVars,
  systemd,
  testers,
  valgrind,
  validatePkgConfig,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wrapGAppsNoGuiHook,
  xdg-dbus-proxy,
  xmlto,
  xorg,
  zstd,
  withAutoSideloading ? false,
  withDconf ? lib.meta.availableOn stdenv.hostPlatform dconf,
  withDocbookDocs ? true,
  withGlibNetworking ? lib.meta.availableOn stdenv.hostPlatform glib-networking,
  withGtkDoc ?
    withDocbookDocs
    && stdenv.buildPlatform.canExecute stdenv.hostPlatform
    # https://github.com/mesonbuild/meson/pull/14257
    && !stdenv.hostPlatform.isStatic,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  withMalcontent ? lib.meta.availableOn stdenv.hostPlatform malcontent,
  withMan ? withDocbookDocs,
  withP11Kit ? lib.meta.availableOn stdenv.hostPlatform p11-kit,
  withPolkit ? lib.meta.availableOn stdenv.hostPlatform polkit,
  withSELinuxModule ? false,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flatpak";
  version = "1.16.1";

  # TODO: split out lib once we figure out what to do with triggerdir
  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withDocbookDocs [
    "doc"
  ]
  ++ lib.optionals withGtkDoc [
    "devdoc"
  ]
  ++ lib.optional finalAttrs.doCheck "installedTests"
  ++ lib.optional withMan "man";

  src = fetchurl {
    url = "https://github.com/flatpak/flatpak/releases/download/${finalAttrs.version}/flatpak-${finalAttrs.version}.tar.xz";
    hash = "sha256-K0fo8tkNNdKTOe144abquzbu+pz6WlyjsNHydQLENnU=";
  };

  patches = [
    # Use flatpak from PATH to avoid references to `/nix/store` in `/desktop` files.
    # Applications containing `DBusActivatable` entries should be able to find the flatpak binary.
    # https://github.com/NixOS/nixpkgs/issues/138956
    ./binary-path.patch

    # Try mounting fonts and icons from NixOS locations if FHS locations don't exist.
    # https://github.com/NixOS/nixpkgs/issues/119433
    ./fix-fonts-icons.patch

    # Nix environment hacks should not leak into the apps.
    # https://github.com/NixOS/nixpkgs/issues/53441
    ./unset-env-vars.patch

    # The icon validator needs to access the gdk-pixbuf loaders in the Nix store
    # and cannot bind FHS paths since those are not available on NixOS.
    finalAttrs.passthru.icon-validator-patch
  ]
  ++ lib.optionals finalAttrs.doCheck [
    # Hardcode paths used by tests and change test runtime generation to use files from Nix store.
    # https://github.com/flatpak/flatpak/issues/1460
    (replaceVars ./fix-test-paths.patch {
      inherit
        coreutils
        gettext
        gtk3
        socat
        ;
      dfu = desktop-file-utils;
      hicolorIconTheme = hicolor-icon-theme;
      smi = shared-mime-info;
    })
  ]
  ++ lib.optionals withP11Kit [
    # Hardcode p11-kit path used by Flatpak itself.
    # If disabled, will have to be on PATH.
    (replaceVars ./fix-paths.patch {
      p11kit = lib.getExe p11-kit;
    })
  ];

  # Fixup shebangs in some scripts
  #
  # Don't prefix the already absolute `man` directory with the install prefix
  postPatch = ''
    patchShebangs buildutil/ tests/
    patchShebangs --build subprojects/variant-schema-compiler/variant-schema-compiler

    substituteInPlace doc/meson.build \
      --replace-fail '$MESON_INSTALL_DESTDIR_PREFIX/@1@/@2@' '@1@/@2@'
  '';

  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    (python3.pythonOnBuildForHost.withPackages (p: [ p.pyparsing ]))
    bison
    glib
    meson
    ninja
    pkg-config
    validatePkgConfig
    wayland-scanner
    wrapGAppsNoGuiHook
  ]
  ++ lib.optional withGtkDoc gtk-doc
  ++ lib.optional withIntrospection gobject-introspection
  ++ lib.optional withMan libxslt
  ++ lib.optional withSELinuxModule bzip2
  ++ lib.optionals withDocbookDocs [
    docbook-xsl-nons
    docbook_xml_dtd_45
    xmlto
  ];

  buildInputs = [
    appstream
    curl
    fuse3
    gdk-pixbuf
    gpgme
    gsettings-desktop-schemas
    json-glib
    libarchive
    libcap
    librsvg # for flatpak-validate-icon
    libseccomp
    libxml2
    python3
    wayland
    wayland-protocols
    xorg.libXau
    zstd
  ]
  ++ lib.optional withDconf dconf
  ++ lib.optional withGlibNetworking glib-networking
  ++ lib.optional withMalcontent malcontent
  ++ lib.optional withPolkit polkit
  ++ lib.optional withSystemd systemd;

  # Required by flatpak.pc
  propagatedBuildInputs = [
    glib
    ostree
  ];

  mesonFlags = [
    (lib.mesonBool "auto_sideloading" withAutoSideloading)
    (lib.mesonBool "installed_tests" finalAttrs.finalPackage.doCheck)
    (lib.mesonBool "tests" finalAttrs.finalPackage.doCheck)
    (lib.mesonEnable "dconf" withDconf)
    (lib.mesonEnable "docbook_docs" withDocbookDocs)
    (lib.mesonEnable "gir" withIntrospection)
    (lib.mesonEnable "gtkdoc" withGtkDoc)
    (lib.mesonEnable "malcontent" withMalcontent)
    (lib.mesonEnable "man" withMan)
    (lib.mesonEnable "selinux_module" withSELinuxModule)
    (lib.mesonEnable "system_helper" withPolkit)
    (lib.mesonEnable "systemd" withSystemd)
    (lib.mesonOption "dbus_config_dir" (placeholder "out" + "/share/dbus-1/system.d"))
    (lib.mesonOption "profile_dir" (placeholder "out" + "/etc/profile.d"))
    (lib.mesonOption "system_bubblewrap" (lib.getExe bubblewrap))
    (lib.mesonOption "system_dbus_proxy" (lib.getExe xdg-dbus-proxy))
    (lib.mesonOption "system_fusermount" "/run/wrappers/bin/fusermount3")
    (lib.mesonOption "system_install_dir" "/var/lib/flatpak")
  ];

  nativeCheckInputs = [
    polkit
    socat
    valgrind
  ];

  # TODO: Many issues with temporary files, FHS environments, timeouts, and our current patches
  doCheck = false;

  separateDebugInfo = true;

  passthru = {
    icon-validator-patch = replaceVars ./fix-icon-validation.patch {
      inherit (builtins) storeDir;
    };

    tests = {
      cross-aarch64 = pkgsCross.aarch64-multiplatform.flatpak;

      pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };

      validate-icon = runCommand "test-icon-validation" { } ''
        ${finalAttrs.finalPackage}/libexec/flatpak-validate-icon \
          --sandbox 512 512 \
          "${nixos-icons}/share/icons/hicolor/512x512/apps/nix-snowflake.png" > "$out"

        grep format=png "$out"
      '';

      version = testers.testVersion { package = finalAttrs.finalPackage; };
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Linux application sandboxing and distribution framework";
    homepage = "https://flatpak.org/";
    changelog = "https://github.com/flatpak/flatpak/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "flatpak";
    platforms = lib.platforms.linux;
    pkgConfigModules = [ "flatpak" ];
  };
})
