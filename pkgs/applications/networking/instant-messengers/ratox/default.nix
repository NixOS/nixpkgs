{ stdenv, fetchgit, libtoxcore
, conf ? null }:

with stdenv.lib;

let
  configFile = optionalString (conf!=null) (builtins.toFile "config.h" conf);

in stdenv.mkDerivation rec {
  name = "ratox-0.4.20180303";

  src = fetchgit {
    url = "git://git.2f30.org/ratox.git";
    rev = "269f7f97fb374a8f9c0b82195c21de15b81ddbbb";
    sha256 = "0bpn37h8jvsqd66fkba8ky42nydc8acawa5x31yxqlxc8mc66k74";
  };

  buildInputs = [ libtoxcore ];

  preConfigure = ''
    substituteInPlace config.mk \
      --replace '-lsodium -lopus -lvpx ' ""

    ${optionalString (conf!=null) "cp ${configFile} config.def.h"}
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "FIFO based tox client";
    homepage = http://ratox.2f30.org/;
    license = licenses.isc;
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux;
  };
}
