{ stdenv, fetchurl, perl
, enableACLs ? true, acl ? null
, enableCopyDevicesPatch ? false
}:

assert enableACLs -> acl != null;

stdenv.mkDerivation rec {
  name = "rsync-3.0.9";

  mainSrc = fetchurl {
    url = http://rsync.samba.org/ftp/rsync/src/rsync-3.0.9.tar.gz;
    sha256 = "01bw4klqsrlhh3i9lazd485sd9qx5djvnwa21lj2h3a9sn6hzw9h";
  };

  patchesSrc = fetchurl {
    url = http://rsync.samba.org/ftp/rsync/rsync-patches-3.0.9.tar.gz;
    sha256 = "0c1e9b56e99667dfc47641124460bac61a04c5d2ee89f575c6bc78c7a69005a9";
  };

  srcs = [mainSrc] ++ stdenv.lib.optional enableCopyDevicesPatch patchesSrc;
  patches = [] ++ stdenv.lib.optional enableCopyDevicesPatch "./patches/copy-devices.diff";

  buildInputs = stdenv.lib.optional enableACLs acl;
  buildNativeInputs = [perl];

  meta = {
    homepage = http://samba.anu.edu.au/rsync/;
    description = "A fast incremental file transfer utility";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
