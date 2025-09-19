{
  lib,
  stdenv,
  autoconf,
  automake,
}:
stdenv.mkDerivation {
  pname = "hfsutils";
  version = "3.2.6";

  src = fetchTarball {
    url = "https://ftp.osuosl.org/pub/clfs/conglomeration/hfsutils/hfsutils-3.2.6.tar.gz";
    sha256 = "1pv3sw8jhsd1k2bkyy2r3b3mhiijwaa7jyvmaiw50s7dja2wa9qv";
  };

  preInstall = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/man/man1"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    # hformat fails if HOME is not set.
    export HOME=.
    dd if=/dev/zero of=disk.hfs bs=1k count=800
    ls -lha .
    $out/bin/hformat -l 'Test Disk' disk.hfs
    mount_output="$($out/bin/hmount disk.hfs)"
    echo "$mount_output" | grep 'Volume name is "Test Disk"'
    echo "$mount_output" | grep 'Volume has 803840 bytes free'
    $out/bin/humount
    rm disk.hfs
  '';

  meta = {
    description = "Utilities for working with HFS filesystems";
    longDescription = ''
      A set of utilities for interacting with Apple's MacOS-9-era filesystem, HFS.
      Useful for extracting data from classic MacOS CD-ROMs and HFS-formatted disk images.
    '';
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ nateeag ];
    homepage = "https://www.mars.org/home/rob/proj/hfs/";
  };
}
