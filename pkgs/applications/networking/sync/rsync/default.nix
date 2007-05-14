{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "rsync-2.6.9";
  src = fetchurl {
    url = http://rsync.samba.org/ftp/rsync/rsync-2.6.9.tar.gz;
    sha256 = "1y9kwsyxfgcv2kzlh6bnm95mdwcz30wrmihb61rhx2fdpq0p6hya";
  };
}
