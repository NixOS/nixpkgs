{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  makeWrapper,
  autoreconfHook,
  pkg-config,
  openssl,
  libgcrypt,
  cmocka,
  expect,
  sqlite,
  pcre2,

  # Linux
  libpcap,
  zlib,
  wirelesstools,
  iw,
  ethtool,
  pciutils,
  libnl,
  usbutils,
  tcpdump,
  hostapd,
  wpa_supplicant,
  screen,

  # Cygwin
  libiconv,

  # options
  enableExperimental ? true,
  useGcrypt ? false,
  enableAirolib ? true,
  enableRegex ? true,
  useAirpcap ? stdenv.hostPlatform.isCygwin,
}:
let
  airpcap-sdk = fetchzip {
    pname = "airpcap-sdk";
    version = "4.1.1";
    url = "https://support.riverbed.com/bin/support/download?sid=l3vk3eu649usgu3rj60uncjqqu";
    hash = "sha256-kJhnUvhnF9F/kIJx9NcbRUfIXUSX/SRaO/SWNvdkVT8=";
    stripRoot = false;
    extension = "zip";
  };
in
stdenv.mkDerivation rec {
  pname = "aircrack-ng";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "aircrack-ng";
    repo = "aircrack-ng";
    rev = version;
    hash = "sha256-niQDwiqi5GtBW5HIn0endnqPb/MqllcjsjXw4pTyFKY=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace lib/osdep/linux.c --replace-warn /usr/local/bin ${
      lib.escapeShellArg (
        lib.makeBinPath [
          wirelesstools
        ]
      )
    }
  '';

  configureFlags = [
    (lib.withFeature enableExperimental "experimental")
    (lib.withFeature useGcrypt "gcrypt")
    (lib.withFeatureAs useAirpcap "airpcap" airpcap-sdk)
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    autoreconfHook
  ];
  buildInputs =
    lib.singleton (if useGcrypt then libgcrypt else openssl)
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libpcap
      zlib
      libnl
      iw
      ethtool
      pciutils
    ]
    ++ lib.optional (stdenv.hostPlatform.isCygwin && stdenv.hostPlatform.isClang) libiconv
    ++ lib.optional enableAirolib sqlite
    ++ lib.optional enableRegex pcre2
    ++ lib.optional useAirpcap airpcap-sdk;

  nativeCheckInputs = [
    cmocka
    expect
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram "$out/bin/airmon-ng" --prefix PATH : ${
      lib.escapeShellArg (
        lib.makeBinPath [
          ethtool
          iw
          pciutils
          usbutils
        ]
      )
    }
  '';

  installCheckTarget = "integration";
  nativeInstallCheckInputs =
    [
      cmocka
      expect
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      tcpdump
      hostapd
      wpa_supplicant
      screen
    ];

  meta = {
    description = "WiFi security auditing tools suite";
    homepage = "https://www.aircrack-ng.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ caralice ];
    platforms =
      with lib.platforms;
      builtins.concatLists [
        linux
        darwin
        cygwin
        netbsd
        openbsd
        freebsd
        illumos
      ];
    changelog = "https://github.com/aircrack-ng/aircrack-ng/blob/${src.rev}/ChangeLog";
  };
}
