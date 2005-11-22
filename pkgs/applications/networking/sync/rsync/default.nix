{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "rsync-2.6.6";
  src = fetchurl {
    url = http://rsync.samba.org/ftp/rsync/rsync-2.6.6.tar.gz;
    md5 = "30c4e2849cbeae93f55548453865c2f2";
  };
}
