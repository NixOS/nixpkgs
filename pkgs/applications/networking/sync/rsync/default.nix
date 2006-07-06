{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "rsync-2.6.8";
  src = fetchurl {
    url = http://rsync.samba.org/ftp/rsync/rsync-2.6.8.tar.gz;
    md5 = "082a9dba1f741e6591e5cd748a1233de";
  };
}
