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
  python3,
  qt6,
  rustPlatform,
  rustc,
  stdenv,
  wireguard-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mozillavpn";
  version = "2.27.0";
  src = fetchFromGitHub {
    owner = "mozilla-mobile";
    repo = "mozilla-vpn-client";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-TfiEc5Lptr0ntp4buEEWbQTvNkVjZbdMWDv8CEZa6IM=";
  };
  patches = [
    # Provide default args for LottieStatus::changed so moc can call it (#10420)
    (fetchpatch {
      url = "https://github.com/mozilla-mobile/mozilla-vpn-client/commit/e5abe5714a5b506e398c088d21672f00d6f93240.patch";
      hash = "sha256-DU5wQ1DDF8DbmMIlohoEIDJ7/9+9GVwrvsr51T9bGx8=";
    })
    # Remove Qt.labls.qmlmodels usage (#10422)
    (fetchpatch {
      url = "https://github.com/mozilla-mobile/mozilla-vpn-client/commit/4497972b1bf7b7f215dc6c1227d76d6825f5b958.patch";
      hash = "sha256-RPRdARM/jXSHmTGGjiOrfJ7KVejp3JmUfsN5pmKYPuY=";
    })
    # Qt compat: Make sure to include what we use
    (fetchpatch {
      url = "https://github.com/mozilla-mobile/mozilla-vpn-client/commit/0909d43447a7ddbc6ec20d108637524552848bd6.patch";
      hash = "sha256-Hpn69hQxa269XH+Ku/MYD2GwdFhfCX4yoVRCEDfIOKc=";
    })
    # Use QDesktopUnixServices after qt 6.9.0
    (fetchpatch {
      url = "https://github.com/mozilla-mobile/mozilla-vpn-client/pull/10424/commits/81e66044388459ffe2b08804ab5a326586ac7113.patch";
      hash = "sha256-+v3NoTAdkjKEyBPbbJZQ2d11hJMyE3E4B9uYUerVa7c=";
    })
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
    hash = "sha256-SGC+YT5ATV/ZaP/wrm3c31OQBw6Pk8ZSXjxEPFdP2f8=";
  };

  buildInputs = [
    libcap
    libgcrypt
    libgpg-error
    libsecret
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
      --replace-fail '/usr/share/dbus-1' "$out/share/dbus-1" \
      --replace-fail '${"$"}{SYSTEMD_UNIT_DIR}' "$out/lib/systemd/system"

    substituteInPlace extension/CMakeLists.txt \
      --replace-fail '/etc' "$out/etc"

    substituteInPlace extension/socks5proxy/bin/CMakeLists.txt \
      --replace-fail '${"$"}{SYSTEMD_UNIT_DIR}' "$out/lib/systemd/system"

    ln -s '${finalAttrs.netfilter.goModules}' linux/netfilter/vendor
  '';

  cmakeFlags = [
    "-DQT_LCONVERT_EXECUTABLE=${qt6.qttools.dev}/bin/lconvert"
    "-DQT_LUPDATE_EXECUTABLE=${qt6.qttools.dev}/bin/lupdate"
    "-DQT_LRELEASE_EXECUTABLE=${qt6.qttools.dev}/bin/lrelease"
  ];
  dontFixCmake = true;

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ wireguard-tools ])
  ];

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
