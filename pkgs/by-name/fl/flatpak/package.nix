{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  runCommand,
  appstream,
  autoreconfHook,
  bison,
  bubblewrap,
  buildPackages,
  bzip2,
  coreutils,
  curl,
  dbus,
  dconf,
  desktop-file-utils,
  docbook_xml_dtd_45,
  docbook-xsl-nons,
  fuse3,
  gettext,
  glib,
  glib-networking,
  gobject-introspection,
  gpgme,
  gsettings-desktop-schemas,
  gtk3,
  gtk-doc,
  hicolor-icon-theme,
  intltool,
  json-glib,
  libarchive,
  libcap,
  librsvg,
  libseccomp,
  libxml2,
  libxslt,
  nix-update-script,
  nixosTests,
  nixos-icons,
  ostree,
  p11-kit,
  pkg-config,
  polkit,
  pkgsCross,
  python3,
  shared-mime-info,
  socat,
  substituteAll,
  systemd,
  testers,
  valgrind,
  which,
  wrapGAppsNoGuiHook,
  xdg-dbus-proxy,
  xmlto,
  xorg,
  xz,
  zstd,
  withGtkDoc ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flatpak";
  version = "1.14.10";

  # TODO: split out lib once we figure out what to do with triggerdir
  outputs = [
    "out"
    "dev"
    "man"
    "doc"
    "devdoc"
    "installedTests"
  ];

  separateDebugInfo = true;

  src = fetchurl {
    url = "https://github.com/flatpak/flatpak/releases/download/${finalAttrs.version}/flatpak-${finalAttrs.version}.tar.xz";
    hash = "sha256-a73HkIEnNQrYWkpH1wKSyi9MRul3sysf0jHCpxnYIc0=";
  };

  patches = [
    # Hardcode paths used by tests and change test runtime generation to use files from Nix store.
    # https://github.com/flatpak/flatpak/issues/1460
    (substituteAll {
      src = ./fix-test-paths.patch;
      inherit
        coreutils
        gettext
        socat
        gtk3
        ;
      smi = shared-mime-info;
      dfu = desktop-file-utils;
      hicolorIconTheme = hicolor-icon-theme;
    })

    # Hardcode paths used by Flatpak itself.
    (substituteAll {
      src = ./fix-paths.patch;
      p11kit = "${p11-kit.bin}/bin/p11-kit";
    })

    # Allow gtk-doc to find schemas using XML_CATALOG_FILES environment variable.
    # Patch taken from gtk-doc expression.
    ./respect-xml-catalog-files-var.patch

    # Nix environment hacks should not leak into the apps.
    # https://github.com/NixOS/nixpkgs/issues/53441
    ./unset-env-vars.patch

    # Use flatpak from PATH to avoid references to `/nix/store` in `/desktop` files.
    # Applications containing `DBusActivatable` entries should be able to find the flatpak binary.
    # https://github.com/NixOS/nixpkgs/issues/138956
    ./binary-path.patch

    # The icon validator needs to access the gdk-pixbuf loaders in the Nix store
    # and cannot bind FHS paths since those are not available on NixOS.
    finalAttrs.passthru.icon-validator-patch

    # Try mounting fonts and icons from NixOS locations if FHS locations don't exist.
    # https://github.com/NixOS/nixpkgs/issues/119433
    ./fix-fonts-icons.patch

    # TODO: Remove when updating to 1.16
    # Ensure flatpak uses the system's zoneinfo from $TZDIR
    # https://github.com/NixOS/nixpkgs/issues/238386
    (fetchpatch {
      url = "https://github.com/flatpak/flatpak/pull/5850/commits/a8a35bf4d9fc3d76e1a5049a6a591faec04a42fd.patch";
      hash = "sha256-JqkPbnzgZNZq/mplZqohhHFdjRrvYFjE4C02pI3feBo=";
    })
    (fetchpatch {
      url = "https://github.com/flatpak/flatpak/pull/5850/commits/5ea13b09612215559081c27b60df4fb720cb08d5.patch";
      hash = "sha256-BWbyQ2en3RtN4Ec5n62CULAhvywlQLhcl3Fmd4fsR1s=";
    })
    (fetchpatch {
      url = "https://github.com/flatpak/flatpak/pull/5850/commits/7c8a81f08908019bbf69358de199748a9bcb29e3.patch";
      hash = "sha256-RiG2jPmG+Igskxv8oQquOUYsG4srgdMXWe34ojMXslo=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    libxml2
    docbook_xml_dtd_45
    docbook-xsl-nons
    which
    gobject-introspection
    gtk-doc
    intltool
    libxslt
    pkg-config
    xmlto
    bison
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    appstream
    bubblewrap
    bzip2
    curl
    dbus
    dconf
    gpgme
    json-glib
    libarchive
    libcap
    libseccomp
    libxml2
    xz
    zstd
    polkit
    python3
    systemd
    xorg.libXau
    fuse3
    gsettings-desktop-schemas
    glib-networking
    librsvg # for flatpak-validate-icon
  ] ++ lib.optionals withGtkDoc [ gtk-doc ];

  # Required by flatpak.pc
  propagatedBuildInputs = [
    glib
    ostree
  ];

  nativeCheckInputs = [ valgrind ];

  # TODO: some issues with temporary files
  doCheck = false;
  strictDeps = true;

  NIX_LDFLAGS = "-lpthread";

  enableParallelBuilding = true;

  configureFlags = [
    "--with-curl"
    "--with-system-bubblewrap=${lib.getExe bubblewrap}"
    "--with-system-dbus-proxy=${lib.getExe xdg-dbus-proxy}"
    "--with-dbus-config-dir=${placeholder "out"}/share/dbus-1/system.d"
    "--with-profile-dir=${placeholder "out"}/etc/profile.d"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--enable-gtk-doc=${if withGtkDoc then "yes" else "no"}"
    "--enable-installed-tests"
    "--enable-selinux-module=no"
  ];

  makeFlags = [
    "installed_testdir=${placeholder "installedTests"}/libexec/installed-tests/flatpak"
    "installed_test_metadir=${placeholder "installedTests"}/share/installed-tests/flatpak"
  ];

  postPatch =
    let
      vsc-py = python3.pythonOnBuildForHost.withPackages (pp: [ pp.pyparsing ]);
    in
    ''
      patchShebangs buildutil
      patchShebangs tests
      PATH=${lib.makeBinPath [ vsc-py ]}:$PATH patchShebangs --build subprojects/variant-schema-compiler/variant-schema-compiler

      substituteInPlace configure.ac \
        --replace-fail '$BWRAP --' ${
          lib.escapeShellArg (stdenv.hostPlatform.emulator buildPackages + " $BWRAP --")
        } \
        --replace-fail '$DBUS_PROXY --' ${
          lib.escapeShellArg (stdenv.hostPlatform.emulator buildPackages + " $DBUS_PROXY --")
        }
    '';

  passthru = {
    icon-validator-patch = substituteAll {
      src = ./fix-icon-validation.patch;
      inherit (builtins) storeDir;
    };

    updateScript = nix-update-script { };

    tests = {
      cross = pkgsCross.aarch64-multiplatform.flatpak;

      installedTests = nixosTests.installed-tests.flatpak;

      validate-icon = runCommand "test-icon-validation" { } ''
        ${finalAttrs.finalPackage}/libexec/flatpak-validate-icon \
          --sandbox 512 512 \
          "${nixos-icons}/share/icons/hicolor/512x512/apps/nix-snowflake.png" > "$out"

        grep format=png "$out"
      '';

      version = testers.testVersion { package = finalAttrs.finalPackage; };
    };
  };

  meta = {
    description = "Linux application sandboxing and distribution framework";
    homepage = "https://flatpak.org/";
    changelog = "https://github.com/flatpak/flatpak/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "flatpak";
    platforms = lib.platforms.linux;
  };
})
