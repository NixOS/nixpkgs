{ fetchurl }:

rec {
  version = "0.12.4";
  src = fetchurl {
    url = "https://github.com/quassel/quassel/archive/${version}.tar.gz";
    sha256 = "0q2qlhy1d6glw9pwxgcgwvspd1mkk3yi6m21dx9gnj86bxas2qs2";
  };
}
