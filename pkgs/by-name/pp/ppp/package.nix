{
  autoreconfHook,
  bash,
  fetchFromGitHub,
  fetchpatch,
  lib,
  libpcap,
  libxcrypt,
  linux-pam,
  nixosTests,
  openssl,
  pkg-config,
  stdenv,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemdMinimal,
  systemdMinimal,
}:

stdenv.mkDerivation rec {
  version = "2.5.2";
  pname = "ppp";

  src = fetchFromGitHub {
    owner = "ppp-project";
    repo = "ppp";
    tag = "v${version}";
    hash = "sha256-NV8U0F8IhHXn0YuVbfFr992ATQZaXA16bb5hBIwm9Gs=";
  };

  patches = [
    # Fix build with gcc15
    # https://github.com/ppp-project/ppp/pull/548
    (fetchpatch {
      url = "https://github.com/ppp-project/ppp/commit/05361692ee7d6260ce5c04c9fa0e5a1aa7565323.patch";
      hash = "sha256-ybuWyA1t9IJ1Sg06a0b0tin4qssr0qzmenfGoA1X0BE=";
    })
  ];

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-openssl=${openssl.dev}"
    (lib.enableFeature withSystemd "systemd")
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    bash
    libpcap
    libxcrypt
    linux-pam
    openssl
  ]
  ++ lib.optionals withSystemd [
    systemdMinimal
  ];

  postPatch = ''
    for file in $(find -name Makefile.linux); do
      substituteInPlace "$file" --replace '-m 4550' '-m 550'
    done

    patchShebangs --host \
      scripts/{pon,poff,plog}
  '';

  enableParallelBuilding = true;

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  NIX_LDFLAGS = "-lcrypt";

  installFlags = [
    "sysconfdir=$(out)/etc"
  ];

  postInstall = ''
    install -Dm755 -t $out/bin scripts/{pon,poff,plog}
  '';

  postFixup = ''
    substituteInPlace "$out/bin/pon" --replace "/usr/sbin" "$out/bin"
  '';

  passthru.tests = {
    inherit (nixosTests) pppd;
  };

  meta = {
    homepage = "https://ppp.samba.org";
    description = "Point-to-point implementation to provide Internet connections over serial lines";
    license = with lib.licenses; [
      bsdOriginal
      publicDomain
      gpl2Only
      lgpl2
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ stv0g ];
  };
}
