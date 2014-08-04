{ stdenv, fetchurl, libtoxcore, pidgin, autoconf, automake, libtool, libsodium } :

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

  NIX_LDFLAGS = "-lssp -lsodium";

  preConfigure = "autoreconf -vfi";

  postInstall = "mv $out/lib/purple-2 $out/lib/pidgin";

  buildInputs = [ libtoxcore pidgin autoconf automake libtool libsodium ];

  meta = {
    homepage = http://tox.dhs.org/;
    description = "Tox plugin for Pidgin / libpurple";
    license = stdenv.lib.licenses.gpl3;
  };
}
