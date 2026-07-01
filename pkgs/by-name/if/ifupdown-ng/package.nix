{
  lib,
  stdenv,
  fetchFromGitHub,
  libbsd,
  pkg-config,
  coreutils,
  gawk,
  gnused,
  gnugrep,
  which,
  iproute2,
  kmod,
  dhcpcd,
  ppp,
  wireguard-tools,
  ethtool,
  batctl,
  wpa_supplicant,
  wirelesstools,
  atf,
  kyua,
  withPPP ? false,
  withWireguard ? false,
  withEthtool ? false,
  withBatman ? false,
  withWifi ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ifupdown-ng";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "ifupdown-ng";
    repo = "ifupdown-ng";
    rev = "ifupdown-ng-${finalAttrs.version}";
    hash = "sha256-+M8c59LjJlO1Vdl+Lo5EXjMEaHWemGWvBsDw/MaY/IE=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libbsd ];

  postPatch = ''
    # replace _PATH_STDPATH with a path that includes nix store locations.
    # ifupdown-ng sets PATH to this value before running executor scripts.
    substituteInPlace libifupdown/lifecycle.c \
      --replace-fail '_PATH_STDPATH' '"${
        lib.makeBinPath (
          [
            coreutils
            gawk
            gnused
            gnugrep
            which
            iproute2
            kmod
            dhcpcd
          ]
          ++ lib.optional withPPP ppp
          ++ lib.optional withWireguard wireguard-tools
          ++ lib.optional withEthtool ethtool
          ++ lib.optional withBatman batctl
          ++ lib.optionals withWifi [
            wpa_supplicant
            wirelesstools
          ]
        )
      }"'

    # remove hardcoded FHS paths from executor scripts so they use PATH lookup.
    substituteInPlace executors/linux/dhcp \
      --replace-fail '-x /sbin/dhcpcd' '-x "$(which dhcpcd)"' \
      --replace-fail '-x /usr/sbin/dhclient' '-x "$(which dhclient)"' \
      --replace-fail '-x /sbin/udhcpc' '-x "$(which udhcpc)"' \
      --replace-fail '/sbin/dhcpcd' 'dhcpcd' \
      --replace-fail '/usr/sbin/dhclient' 'dhclient' \
      --replace-fail '/sbin/udhcpc' 'udhcpc'
    substituteInPlace executors/linux/vrf \
      --replace-fail '/sbin/ip' 'ip'
    substituteInPlace executors/linux/wifi \
      --replace-fail '/sbin/wpa_passphrase' 'wpa_passphrase' \
      --replace-fail '/sbin/wpa_supplicant' 'wpa_supplicant' \
      --replace-fail '/usr/sbin/iwconfig' 'iwconfig'
    substituteInPlace tests/linux/dhcp_test \
      --replace-fail '/sbin/dhcpcd' 'dhcpcd' \
      --replace-fail '/usr/sbin/dhclient' 'dhclient' \
      --replace-fail '/sbin/udhcpc' 'udhcpc'
    patchShebangs --build tests
  ''
  + lib.optionalString (!stdenv.hostPlatform.isStatic) ''
    # The Makefile hardcodes -static; remove it to build dynamically.
    substituteInPlace Makefile \
      --replace-fail ' -static ' ' '
  '';

  makeFlags = [
    "SBINDIR=/bin"
    "EXECUTOR_PATH=/libexec/ifupdown-ng"
  ];

  installFlags = [
    "DESTDIR=${placeholder "out"}"
  ];

  doCheck = true;

  nativeCheckInputs = [
    iproute2
    which
    atf
    kyua
  ];

  meta = {
    description = "Next-generation network interface configuration tool";
    longDescription = ''
      ifupdown-ng is a network device manager that is largely compatible
      with Debian ifupdown, BusyBox ifupdown, and other implementations.
      It is used by Alpine Linux as its network management solution.
    '';
    homepage = "https://github.com/ifupdown-ng/ifupdown-ng";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      aanderse
      deinferno
    ];
  };
})
