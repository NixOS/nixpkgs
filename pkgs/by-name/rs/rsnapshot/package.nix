{
  fetchurl,
  lib,
  stdenv,
  perl,
  openssh,
  rsync,
  logger,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rsnapshot";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/rsnapshot/rsnapshot/releases/download/${finalAttrs.version}/rsnapshot-${finalAttrs.version}.tar.gz";
    hash = "sha256-j2r4BG7msCk7JjidCMtpUMf33f/8H3Tu/LCHvUnUT2I=";
  };

  propagatedBuildInputs = [
    perl
    openssh
    rsync
    logger
  ];

  configureFlags = [ "--sysconfdir=/etc --prefix=/" ];
  makeFlags = [ "DESTDIR=$(out)" ];

  patchPhase = ''
    substituteInPlace "Makefile.in" --replace \
      "/usr/bin/pod2man" "${perl}/bin/pod2man"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Filesystem snapshot utility for making backups of local and remote systems";
    homepage = "https://rsnapshot.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
    mainProgram = "rsnapshot";
  };
})
