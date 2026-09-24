{
  fetchurl,
  gitUpdater,
  lib,
  nixosTests,
  replaceVars,
  stdenv,

  # build
  bpftools,
  clang,
  elfutils,
  gettext,
  gnused,
  meson,
  mesonEmulatorHook,
  ninja,
  perl,
  pkg-config,
  vala,
  runtimeShell,
  buildPackages,

  # libs
  audit,
  curl,
  dbus,
  gnutls,
  gobject-introspection,
  jansson,
  libbpf,
  libnvme,
  libpsl,
  libselinux,
  libuuid,
  polkit,
  readline,
  slang,
  systemd,
  udev,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,

  # external deps
  bluez5,
  dhcpcd,
  dnsmasq,
  ethtool,
  iptables,
  kmod,
  libgcrypt,
  libndp,
  modemmanager,
  mobile-broadband-provider-info,
  newt,
  nftables,
  openresolv,
  ppp,

  # docs
  docbook_xml_dtd_412,
  docbook_xml_dtd_42,
  docbook_xml_dtd_43,
  docbook_xsl,
  gtk-doc,
  libxslt,
  python3,

  # install tests
  udevCheckHook,

  # NBFT (NVMe Boot Firmware Table) support, opt-in due to closure size
  # https://github.com/NixOS/nixpkgs/pull/446121#discussion_r2380598419
  withNbft ? false,
}:

let
  inherit (lib)
    mesonBool
    mesonOption
    ;

  pythonForDocs = python3.pythonOnBuildForHost.withPackages (pkgs: with pkgs; [ pygobject3 ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "networkmanager";
  version = "1.58.0";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/releases/${finalAttrs.version}/downloads/NetworkManager-${finalAttrs.version}.tar.xz";
    hash = "sha256-DG8nA6LJsBfNaPv+HS6KGl1/8FE3x1HsQhy6NulFRro=";
  };

  outputs = [
    "out"
    "dev"
    "devdoc"
    "man"
    "doc"
  ];

  # TODO: only disable for clang used for bpf builds
  # this breaks clang target bpf, which does not support -fzero-call-used-regs=used-gpr
  hardeningDisable = [ "zerocallusedregs" ];

  # Right now we hardcode quite a few paths at build time. Probably we should
  # patch networkmanager to allow passing these path in config file. This will
  # remove unneeded build-time dependencies.
  mesonFlags = [
    # System paths
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    (mesonOption "systemdsystemunitdir" (
      if withSystemd then "${placeholder "out"}/etc/systemd/system" else "no"
    ))
    # to enable link-local connections
    (mesonOption "udev_dir" "${placeholder "out"}/lib/udev")
    (mesonOption "dbus_conf_dir" "${placeholder "out"}/share/dbus-1/system.d")
    (mesonOption "kernel_firmware_dir" "/run/current-system/firmware")

    # Platform
    (mesonOption "modprobe" (lib.getExe' kmod "modprobe"))
    (mesonOption "session_tracking" (if withSystemd then "systemd" else "no"))
    (mesonBool "systemd_journal" withSystemd)
    (mesonOption "libaudit" "yes-disabled-by-default")
    (mesonOption "polkit_agent_helper_1" "/run/wrappers/bin/polkit-agent-helper-1")

    # Features
    (mesonBool "clat" (lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform)) # fails to find UAPI headers
    (mesonBool "iwd" true)
    (mesonOption "pppd" (lib.getExe' ppp "pppd"))
    (mesonOption "iptables" (lib.getExe iptables))
    (mesonOption "nft" (lib.getExe nftables))
    (mesonBool "modem_manager" true)
    (mesonBool "nmtui" true)
    (mesonOption "dnsmasq" (lib.getExe dnsmasq))
    (mesonBool "qt" false)
    (mesonBool "nbft" withNbft)

    # Handlers
    (mesonOption "resolvconf" (lib.getExe openresolv))

    # DHCP clients
    (mesonOption "dhcpcd" (lib.getExe dhcpcd))

    # Miscellaneous
    # almost cross-compiles, however fails with
    # ** (process:9234): WARNING **: Failed to load shared library '/nix/store/...-networkmanager-aarch64-unknown-linux-gnu-1.38.2/lib/libnm.so.0' referenced by the typelib: /nix/store/...-networkmanager-aarch64-unknown-linux-gnu-1.38.2/lib/libnm.so.0: cannot open shared object file: No such file or directory
    (mesonBool "docs" (lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform))
    (mesonBool "man" (lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform))
    (mesonOption "tests" "no")
    (mesonOption "crypto" "gnutls")
    (mesonOption "mobile_broadband_provider_info_database" "${mobile-broadband-provider-info}/share/mobile-broadband-provider-info/serviceproviders.xml")
  ];

  patches = [
    (replaceVars ./fix-paths.patch {
      inherit
        ethtool
        gnused
        ;
      inherit runtimeShell;
    })

    # Meson does not support using different directories during build and
    # for installation like Autotools did with flags passed to make install.
    ./fix-install-paths.patch
  ];

  nativeBuildInputs = [
    bpftools
    clang
    elfutils # used to find jansson soname
    gettext
    gobject-introspection
    meson
    ninja
    perl
    pkg-config
    vala
    udevCheckHook

    # Docs
    gtk-doc
    libxslt
    docbook_xsl
    docbook_xml_dtd_412
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    pythonForDocs
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    audit
    bluez5
    curl
    dbus # used to get directory paths with pkg-config during configuration
    dnsmasq
    jansson
    libbpf
    libndp
    libpsl
    libselinux
    libuuid
    mobile-broadband-provider-info
    modemmanager
    newt
    polkit
    ppp
    readline
    slang
    (if withSystemd then systemd else udev)
  ]
  ++ lib.optionals withNbft [
    libnvme
  ];

  propagatedBuildInputs = [
    gnutls
    libgcrypt
  ];

  nativeInstallCheckInputs = [ udevCheckHook ];

  doCheck = false; # requires /sys, the net

  postPatch = ''
    patchShebangs ./tools
    patchShebangs libnm/generate-setting-docs.py

    # TODO: submit upstream
    substituteInPlace meson.build \
      --replace "'vala', req" "'vala', native: false, req"
  ''
  + lib.optionalString withSystemd ''
    substituteInPlace data/NetworkManager.service.in \
      --replace-fail /usr/bin/busctl ${lib.getExe' systemd "busctl"}
  '';

  preBuild = ''
    # Our gobject-introspection patches make the shared library paths absolute
    # in the GIR files. When building docs, the library is not yet installed,
    # though, so we need to replace the absolute path with a local one during build.
    # We are using a symlink that will be overridden during installation.
    mkdir -p ${placeholder "out"}/lib
    ln -s $PWD/src/libnm-client-impl/libnm.so.0 ${placeholder "out"}/lib/libnm.so.0
  '';

  postFixup = lib.optionalString (!lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform) ''
    cp -r ${buildPackages.networkmanager.devdoc} $devdoc
    cp -r ${buildPackages.networkmanager.man} $man
  '';

  doInstallCheck = true;

  passthru = {
    updateScript = gitUpdater {
      odd-unstable = true;
      url = "https://gitlab.freedesktop.org/NetworkManager/NetworkManager.git";
    };
    tests = nixosTests.networking.networkmanager;
  };

  meta = {
    homepage = "https://networkmanager.dev";
    description = "Network configuration and management tool";
    license = lib.licenses.gpl2Plus;
    changelog = "https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/raw/${finalAttrs.version}/NEWS";
    maintainers = with lib.maintainers; [
      obadz
    ];
    teams = [ lib.teams.freedesktop ];
    platforms = lib.platforms.linux;
    badPlatforms = [
      # Mandatory shared libraries.
      lib.systems.inspect.platformPatterns.isStatic
    ];
    identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "gnome" finalAttrs.version;
  };
})
