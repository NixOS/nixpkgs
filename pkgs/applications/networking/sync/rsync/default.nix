{ stdenv, fetchurl
, enableACLs ? true, acl ? null
}:

assert enableACLs -> acl != null;

stdenv.mkDerivation {
  name = "rsync-3.0.5";
  
  src = fetchurl {
    url = http://rsync.samba.org/ftp/rsync/src/rsync-3.0.5.tar.gz;
    sha256 = "1js36yv5s9dic524s7jczqk5myzp67bp24rqhbnikg6lh6pj1b20";
  };

  buildInputs = stdenv.lib.optional enableACLs acl;

  meta = {
    homepage = http://samba.anu.edu.au/rsync/;
    description = "A fast incremental file transfer utility";
  };
}
