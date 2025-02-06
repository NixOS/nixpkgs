{
  lib,
  stdenv,
  appstream,
  bison,
  bubblewrap,
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
  withDocbookDocs ? true,
  withGtkDoc ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  withMan ? true,
  withSELinuxModule ? false,
  withSystemd ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flatpak";
  version = "1.16.0";

  # TODO: split out lib once we figure out what to do with triggerdir
  outputs =
    [
      "out"
      "dev"
    ]
    ++ lib.optionals (withDocbookDocs || withGtkDoc) [
      "devdoc"
      "doc"
    ]
    ++ lib.optional finalAttrs.doCheck "installedTests"
    ++ lib.optional withMan "man";

  src = fetchurl {
    url = "https://github.com/flatpak/flatpak/releases/download/${finalAttrs.version}/flatpak-${finalAttrs.version}.tar.xz";
    hash = "sha256-ywrFZa3LYhJ8bRHtUO5wRNaoNvppw1Sy9LZAoiv6Syo=";
  };

  patches = [
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

    # Hardcode paths used by Flatpak itself.
    (replaceVars ./fix-paths.patch {
      p11kit = lib.getExe p11-kit;
    })

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

  nativeBuildInputs =
    [
      (python3.pythonOnBuildForHost.withPackages (p: [ p.pyparsing ]))
      bison
      gobject-introspection
      meson
      ninja
      pkg-config
      validatePkgConfig
      wrapGAppsNoGuiHook
    ]
    ++ lib.optional withGtkDoc gtk-doc
    ++ lib.optional withMan libxslt
    ++ lib.optional withSELinuxModule bzip2
    ++ lib.optionals withDocbookDocs [
      docbook-xsl-nons
      docbook_xml_dtd_45
      xmlto
    ];

  buildInputs =
    [
      appstream
      curl
      dconf
      fuse3
      gdk-pixbuf
      glib-networking
      gpgme
      gsettings-desktop-schemas
      json-glib
      libarchive
      libcap
      librsvg # for flatpak-validate-icon
      libseccomp
      libxml2
      malcontent
      polkit
      python3
      wayland
      wayland-protocols
      wayland-scanner
      xorg.libXau
      zstd
    ]
    ++ lib.optional withGtkDoc gtk-doc
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
    (lib.mesonEnable "selinux_module" withSELinuxModule)
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
