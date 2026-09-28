{
  lib,
  stdenv,
  fetchFromGitHub,
  libbsd,
  pkg-config,
  coreutils,
  iproute2,
}:

stdenv.mkDerivation {
  pname = "ifupdown-ng";
  version = "unstable-2025-09-12";

  src = fetchFromGitHub {
    owner = "ifupdown-ng";
    repo = "ifupdown-ng";
    rev = "fb07d0824b20d178e7acca9e85296822ac2539ac";
    hash = "sha256-c06NbF0LpyK3hTMxCeWyQcUP9dL17hOm3993wjW/OzQ=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libbsd ];

  postPatch = ''
    # The Makefile hardcodes -static; remove it to build dynamically.
    substituteInPlace Makefile \
      --replace-fail ' -static ' ' '

    # replace _PATH_STDPATH with a path that includes nix store locations.
    # ifupdown-ng sets PATH to this value before running executor scripts.
    substituteInPlace libifupdown/lifecycle.c \
      --replace-fail '_PATH_STDPATH' '"${
        lib.makeBinPath [
          iproute2
          coreutils
        ]
      }:/usr/bin:/bin"'

    # remove hardcoded FHS paths from executor scripts so they use PATH lookup.
    substituteInPlace executors/linux/dhcp \
      --replace-fail '/sbin/dhcpcd' 'dhcpcd' \
      --replace-fail '/usr/sbin/dhclient' 'dhclient' \
      --replace-fail '/sbin/udhcpc' 'udhcpc'
    substituteInPlace executors/linux/vrf \
      --replace-fail '/sbin/ip' 'ip'
    substituteInPlace executors/linux/wifi \
      --replace-fail '/sbin/wpa_passphrase' 'wpa_passphrase' \
      --replace-fail '/sbin/wpa_supplicant' 'wpa_supplicant' \
      --replace-fail '/usr/sbin/iwconfig' 'iwconfig'
  '';

  makeFlags = [
    "SBINDIR=/bin"
    "EXECUTOR_PATH=/libexec/ifupdown-ng"
  ];

  installFlags = [
    "DESTDIR=${placeholder "out"}"
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
    maintainers = with lib.maintainers; [ aanderse ];
  };
}
