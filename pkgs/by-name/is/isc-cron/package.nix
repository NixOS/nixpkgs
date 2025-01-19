{
  lib,
  fetchurl,
  stdenv,
  substituteAll,
  vim,
  sendmailPath ? "/usr/sbin/sendmail",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cron";
  version = "4.1";

  src = fetchurl {
    url = "ftp://ftp.isc.org/isc/cron/cron_${finalAttrs.version}.shar";
    hash = "sha256-xEWDd1b7mI8slduNxV15N9FLygzfopLegTIsolVuw5o=";
  };

  patches = [
    (substituteAll {
      src = ./0000-nixpkgs-specific.diff;
      inherit sendmailPath;
      viPath = lib.getExe' vim "vim";
      defPath = lib.concatStringsSep ":" [
        "/run/wrappers/bin"
        "/nix/var/nix/profiles/default/bin"
        "/run/current-system/sw/bin"
        "/usr/bin"
        "/bin"
      ];
    })
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "DESTROOT=$(out)"
  ];

  hardeningEnable = [ "pie" ];

  unpackCmd = ''
    mkdir cron
    pushd cron
    sh $curSrc
    popd
  '';

  # do not set sticky bit in /nix/store
  # further, do not strip during install since it breaks on cross-compilation
  # and we will do this ourselves as needed
  postPatch = ''
    substituteInPlace Makefile \
      --replace ' -o root' ' ' \
      --replace 111 755 \
      --replace 4755 0755 \
      --replace ' -s cron' ' cron'
  '';

  preInstall = ''
    mkdir -p $out/{{,s}bin,share/man/man{1,5,8}}
  '';

  meta = {
    homepage = "https://ftp.isc.org/isc/cron/";
    description = "Daemon for running commands at specific times";
    license = lib.licenses.bsd0;
    mainProgram = "cron";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
