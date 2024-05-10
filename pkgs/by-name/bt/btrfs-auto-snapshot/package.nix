{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  getopt,
  gnugrep,
  gnused,
  gawk,
  btrfs-progs,
  syslogSupport ? true,
  util-linux ? null,
}:
assert syslogSupport -> util-linux != null;
stdenv.mkDerivation rec {
  version = "2.0.4";
  pname = "btrfs-auto-snapshot";

  src = fetchFromGitHub {
    owner = "hunleyd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QpuwkGaYAkpu5hYyb360Mr5tHsZc2LzMlKtpS8CyyhI=";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 btrfs-auto-snapshot $out/bin/btrfs-auto-snapshot
  '';

  wrapperPath =
    with lib;
    makeBinPath (
      [
        coreutils
        getopt
        gnugrep
        gnused
        gawk
        btrfs-progs
      ]
      ++ optional syslogSupport util-linux
    );

  postFixup = ''
    wrapProgram $out/bin/btrfs-auto-snapshot \
      --prefix PATH : "${wrapperPath}"
  '';

  meta = with lib; {
    description = "BTRFS Automatic Snapshot Service for Linux";
    homepage = "https://github.com/hunleyd/btrfs-auto-snapshot";
    license = licenses.gpl2;
    mainProgram = "btrfs-auto-snapshot";
    maintainers = with maintainers; [ motiejus ];
    platforms = platforms.linux;

    longDescription = ''
      btrfs-auto-snapshot is a Bash script designed to bring as much of the
      functionality of the wonderful ZFS snapshot tool zfs-auto-snapshot to
      BTRFS as possible. Designed to run from cron (using
      /etc/cron.{daily,hourly,weekly}) it automatically creates a snapshot of
      the specified BTRFS filesystem (or, optionally, all of them) and then
      automatically purges the oldest snapshots of that type (hourly, daily, et
      al) based on a user-defined retention policy.

      Snapshots are stored in a '.btrfs' directory at the root of the BTRFS
      filesystem being snapped and are read-only by default.
    '';
  };
}
