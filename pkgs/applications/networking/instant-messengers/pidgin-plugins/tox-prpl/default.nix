{ stdenv, fetchurl, libtoxcore, pidgin, autoconf, automake, libtool } :

let
  version = "17a3fd9199";
  date = "20131012";
in
stdenv.mkDerivation rec {
  name = "tox-prpl-${date}-${version}";

  src = fetchurl {
    url = "https://github.com/jin-eld/tox-prpl/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "0sz5wkyfwmhaj652xpsxq4p252cmmfa1vy6mp3jfyn145c758v9n";
  };

  preConfigure = "autoreconf -vfi";

  buildInputs = [ libtoxcore pidgin autoconf automake libtool];

  meta = {
    homepage = http://tox.dhs.org/;
    description = "Tox plugin for Pidgin / libpurple";
    license = "GPLv3";
  };
}
