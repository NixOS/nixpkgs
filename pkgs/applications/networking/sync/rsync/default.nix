{ stdenv, fetchurl, perl
, enableACLs ? true, acl ? null
, enableCopyDevicesPatch ? false
}:

assert enableACLs -> acl != null;

stdenv.mkDerivation rec {
  name = "rsync-${version}";
  version = "3.1.1";

  mainSrc = fetchurl {
    # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
    url = "http://rsync.samba.org/ftp/rsync/src/rsync-${version}.tar.gz";
    sha256 = "0896iah6w72q5izpxgkai75bn40dqkqifi2ivcxjzr2zrx7kdr3x";
  };

  patchesSrc = fetchurl {
    # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
    url = "http://rsync.samba.org/ftp/rsync/rsync-patches-${version}.tar.gz";
    sha256 = "0iij996xbyn20yr4w3kv3rw3cx4jwkg2k85x6w5hb5xlgsis8zjl";
  };

  srcs = [mainSrc] ++ stdenv.lib.optional enableCopyDevicesPatch patchesSrc;
  patches = stdenv.lib.optional enableCopyDevicesPatch "./patches/copy-devices.diff";

  buildInputs = stdenv.lib.optional enableACLs acl;
  nativeBuildInputs = [perl];

  configureFlags = "--with-nobody-group=nogroup";

  meta = with stdenv.lib; {
    homepage = http://rsync.samba.org/;
    description = "A fast incremental file transfer utility";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ simons emery ];
  };
}
