{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "rsync-3.0.0";
  src = fetchurl {
    url = http://rsync.samba.org/ftp/rsync/src/rsync-3.0.0.tar.gz;
    sha256 = "0sd11rb5cpa5a2dl3h7cn1q4nmdkc07hf9vr3yvrkqwxpfspss8p";
  };
}
