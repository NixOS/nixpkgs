{
  _experimental-update-script-combinators,
  buildGoModule,
  cargo,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  go,
  lib,
  libcap,
  libgcrypt,
  libgpg-error,
  libsecret,
  nix-update-script,
  pkg-config,
  polkit,
  python3,
  qt6,
  rustPlatform,
  rustc,
  stdenv,
  wireguard-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mozillavpn";
  version = "2.33.1";
  src = fetchFromGitHub {
    owner = "mozilla-mobile";
    repo = "mozilla-vpn-client";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-DsartzFmJFmG++seImaZXnCKZurFXtxTGmSX7DeK3M8=";
  };
  patches = [
  ];

  netfilter = buildGoModule {
    pname = "${finalAttrs.pname}-netfilter";
    inherit (finalAttrs)
      version
      src
      patches
      ;
    modRoot = "linux/netfilter";
    vendorHash = "sha256-Cmo0wnl0z5r1paaEf1MhCPbInWeoMhGjnxCxGh0cyO8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src patches;
    hash = "sha256-yEZBW1Jc4GUx4eZ3CVlNVKF+MNUtR6qvcOJZz2TgTO4=";
  };

  buildInputs = [
    libcap
    libgcrypt
    libgpg-error
    libsecret
    polkit
    qt6.qt5compat
    qt6.qtbase
    qt6.qtnetworkauth
    qt6.qtsvg
    qt6.qtwayland
    qt6.qtwebsockets
  ];
  nativeBuildInputs = [
    cargo
    cmake
    go
    pkg-config
    python3
    python3.pkgs.glean-parser
    python3.pkgs.pyyaml
    python3.pkgs.setuptools
    qt6.qttools
    qt6.wrapQtAppsHook
    rustPlatform.cargoSetupHook
    rustc
  ];

  postPatch = ''
    substituteInPlace scripts/cmake/addons.cmake \
      --replace-fail 'set(ADDON_BUILD_ARGS ' 'set(ADDON_BUILD_ARGS -q ${qt6.qttools.dev}/bin '

    substituteInPlace src/cmake/linux.cmake \
      --replace-fail '/usr/share/dbus-1' '${"$"}{CMAKE_INSTALL_DATADIR}/dbus-1' \
      --replace-fail '${"$"}{POLKIT_POLICY_DIR}' '${"$"}{CMAKE_INSTALL_DATADIR}/polkit-1/actions' \
      --replace-fail '${"$"}{SYSTEMD_UNIT_DIR}' '${"$"}{CMAKE_INSTALL_LIBDIR}/systemd/system'

    substituteInPlace extension/CMakeLists.txt \
      --replace-fail '/etc' '${"$"}{CMAKE_INSTALL_SYSCONFDIR}'

    substituteInPlace extension/socks5proxy/bin/CMakeLists.txt \
      --replace-fail '${"$"}{SYSTEMD_UNIT_DIR}' '${"$"}{CMAKE_INSTALL_LIBDIR}/systemd/system'

    ln -s '${finalAttrs.netfilter.goModules}' linux/netfilter/vendor

    patchShebangs scripts/utils/xlifftool.py
  '';

  cmakeFlags = [
    "-DQT_LCONVERT_EXECUTABLE=${qt6.qttools.dev}/bin/lconvert"
    "-DQT_LUPDATE_EXECUTABLE=${qt6.qttools.dev}/bin/lupdate"
    "-DQT_LRELEASE_EXECUTABLE=${qt6.qttools.dev}/bin/lrelease"
  ];

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ wireguard-tools ])
  ];

  postInstall = ''
    mkdir "$out/share/polkit-1/rules.d"
    cp ../linux/org.mozilla.vpn.rules-others "$out/share/polkit-1/rules.d/org.mozilla.vpn.rules"
  '';

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script { })
    (nix-update-script {
      attrPath = "mozillavpn.netfilter";
      extraArgs = [ "--version=skip" ];
    })
  ];

  meta = {
    description = "Client for the Mozilla VPN service";
    mainProgram = "mozillavpn";
    homepage = "https://vpn.mozilla.org/";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ andersk ];
    platforms = lib.platforms.linux;
  };
})
