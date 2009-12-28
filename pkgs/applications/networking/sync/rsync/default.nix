{ stdenv, fetchurl
, enableACLs ? true, acl ? null
}:

assert enableACLs -> acl != null;

stdenv.mkDerivation {
  name = "rsync-3.0.6";
  
  src = fetchurl {
    url = http://rsync.samba.org/ftp/rsync/src/rsync-3.0.6.tar.gz;
    sha256 = "1cz1adlshjwwi41yqhw7wph7vq58a73b4zgs8piv6rnbcj9rdk1k";
  };

  buildInputs = stdenv.lib.optional enableACLs acl;

  meta = {
    homepage = http://samba.anu.edu.au/rsync/;
    description = "A fast incremental file transfer utility";
  };
}
