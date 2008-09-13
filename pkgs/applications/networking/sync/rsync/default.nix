{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "rsync-3.0.4";
  src = fetchurl {
    url = http://rsync.samba.org/ftp/rsync/src/rsync-3.0.4.tar.gz;
    sha256 = "0lfyrs8vj47p1p19b0f5grxhxcn00hpb1yvvprbwzr6j077ljfkl";
  };
}
