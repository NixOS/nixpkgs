{
  autoreconfHook,
  bash,
  fetchFromGitHub,
  gitUpdater,
  lib,
  libpcap,
  libxcrypt,
  linux-pam,
  nixosTests,
  openssl,
  pkg-config,
  stdenv,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
  systemdLibs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ppp";
  version = "2.5.5";

  src = fetchFromGitHub {
    owner = "ppp-project";
    repo = "ppp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ny1To4tzfqUT13jMVgKuW36tjMB07bKDFUV+sLdOobM=";
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
    systemdLibs
  ];

  strictDeps = true;

  postPatch = ''
    for file in $(find -name Makefile.linux); do
      substituteInPlace "$file" --replace-fail '-m 4550' '-m 550'
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
    substituteInPlace "$out/bin/pon" --replace-fail "/usr/sbin" "$out/bin"
  '';

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
    tests = {
      inherit (nixosTests) pppd;
    };
  };

  __structuredAttrs = true;

  meta = {
    changelog = "https://github.com/ppp-project/ppp/releases/tag/${finalAttrs.src.tag}";
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
