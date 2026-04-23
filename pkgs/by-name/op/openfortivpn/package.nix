{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  openssl,
  ppp,
  systemd,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  withPpp ? stdenv.hostPlatform.isLinux,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openfortivpn";
  version = "1.24.1";

  src = fetchFromGitHub {
    owner = "adrienverge";
    repo = "openfortivpn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zJSEBfhb2dFEOW/sJyB7xFLGGUQLjkz20V80L0ew7J8=";
  };

  # we cannot write the config file to /etc and as we don't need the file, so drop it
  postPatch = ''
    substituteInPlace Makefile.am \
      --replace '$(DESTDIR)$(confdir)' /tmp
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optional withSystemd systemd
  ++ lib.optional withPpp ppp;

  configureFlags = [
    "--sysconfdir=/etc"
  ]
  ++ lib.optional withSystemd "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ++ lib.optional withPpp "--with-pppd=${ppp}/bin/pppd"
  # configure: error: cannot check for file existence when cross compiling
  ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "--disable-proc";

  enableParallelBuilding = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Client for PPP+SSL VPN tunnel services";
    homepage = "https://github.com/adrienverge/openfortivpn";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ madjar ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "openfortivpn";
  };
})
