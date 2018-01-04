{ stdenv, fetchgit, libtoxcore
, conf ? null }:

with stdenv.lib;

let
  configFile = optionalString (conf!=null) (builtins.toFile "config.h" conf);
in

stdenv.mkDerivation rec {
  name = "ratox-0.4";

  src = fetchgit {
    url = "git://git.2f30.org/ratox.git";
    rev = "0db821b7bd566f6cfdc0cc5a7bbcc3e5e92adb4c";
    sha256 = "0wmf8hydbcq4bkpsld9vnqw4zfzf3f04vhgwy17nd4p5p389fbl5";
  };

  patches = [ ./ldlibs.patch ];

  buildInputs = [ libtoxcore ];

  preConfigure = optionalString (conf!=null) "cp ${configFile} config.def.h";

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "FIFO based tox client";
    homepage = http://ratox.2f30.org/;
    license = licenses.isc;
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux;
  };
}
