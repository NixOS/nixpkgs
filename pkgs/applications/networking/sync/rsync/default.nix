{ stdenv, fetchurl, perl
, enableACLs ? true, acl ? null
}:

assert enableACLs -> acl != null;

stdenv.mkDerivation {
  name = "rsync-3.0.7";
  
  src = fetchurl {
    url = http://rsync.samba.org/ftp/rsync/src/rsync-3.0.7.tar.gz;
    sha256 = "1j77vwz6q3dvgr8w6wvigd5v4m5952czaqdvihr8di13q0b0vq4y";
  };

  buildInputs = [perl] ++ stdenv.lib.optional enableACLs acl;

  meta = {
    homepage = http://samba.anu.edu.au/rsync/;
    description = "A fast incremental file transfer utility";
  };
}
