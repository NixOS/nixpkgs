{
  autoreconfHook,
  bash,
  fetchFromGitHub,
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

stdenv.mkDerivation (finalAttrs: {
  version = "2.5.3";
  pname = "ppp";

  src = fetchFromGitHub {
    owner = "ppp-project";
    repo = "ppp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dl0mjiCFpeJwJC7UmJc0vx6K0FOrN4ORTIXEKG5Ykrg=";
  };

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

  env.NIX_LDFLAGS = "-lcrypt";

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
})
