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
  version = "2.24.3";
  src = fetchFromGitHub {
    owner = "mozilla-mobile";
    repo = "mozilla-vpn-client";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-GRt0diDt8bEeMfDwiEtYyR+20/bJAVcDal9eGfvk340=";
  };
  patches = [
    # Fix build errors from deprecated `QByteArray::count()`, `QVariant::type()`, `QEventPoint::pos()` (#9961)
    (fetchpatch {
      url = "https://github.com/mozilla-mobile/mozilla-vpn-client/commit/b4077b9927d9208118e81694dce490dac2f0e76f.patch";
      hash = "sha256-Vx7aHEBxubthqsmH37ZZDJDPI9jE9vS/p+JNJP6eUlI=";
    })
    # Re:#9966 Fix Crash in MZFlickable
    (fetchpatch {
      url = "https://github.com/mozilla-mobile/mozilla-vpn-client/pull/9984/commits/485a2ad8feab6b1dee7c672ce03736d819fd9d37.patch";
      includes = [ "nebula/ui/components/MZFlickable.qml" ];
      hash = "sha256-fnOXBTsuQC3kqAvHgoJ7rRGX5ra0R/MO8M9Ysys/l7Q=";
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

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src patches;
    hash = "sha256-ryJFvnJIiDKf2EqlzHj79hSPYrD+3UtZ5lT/QeFv6V0=";
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
    substituteInPlace src/cmake/linux.cmake \
      --replace '/etc/xdg/autostart' "$out/etc/xdg/autostart" \
      --replace '/usr/share/dbus-1' "$out/share/dbus-1" \
      --replace '${"$"}{SYSTEMD_UNIT_DIR}' "$out/lib/systemd/system"

    substituteInPlace extension/CMakeLists.txt \
      --replace '/etc' "$out/etc"

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
