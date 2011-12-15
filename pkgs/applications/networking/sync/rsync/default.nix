{ stdenv, fetchurl, perl
, enableACLs ? true, acl ? null
}:

assert enableACLs -> acl != null;

stdenv.mkDerivation {
  name = "rsync-3.0.9";

  src = fetchurl {
    url = http://rsync.samba.org/ftp/rsync/src/rsync-3.0.9.tar.gz;
    sha256 = "01bw4klqsrlhh3i9lazd485sd9qx5djvnwa21lj2h3a9sn6hzw9h";
  };

  buildInputs = stdenv.lib.optional enableACLs acl;
  buildNativeInputs = [perl];

  meta = {
    homepage = http://samba.anu.edu.au/rsync/;
    description = "A fast incremental file transfer utility";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
