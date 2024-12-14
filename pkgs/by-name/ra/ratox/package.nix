{
  lib,
  stdenv,
  fetchgit,
  libtoxcore,
  conf ? null,
}:

let
  configFile = lib.optionalString (conf != null) (builtins.toFile "config.h" conf);

in
stdenv.mkDerivation {
  pname = "ratox";
  version = "0.4.20180303";

  src = fetchgit {
    url = "git://git.2f30.org/ratox.git";
    rev = "269f7f97fb374a8f9c0b82195c21de15b81ddbbb";
    sha256 = "0bpn37h8jvsqd66fkba8ky42nydc8acawa5x31yxqlxc8mc66k74";
  };

  buildInputs = [ libtoxcore ];

  preConfigure = ''
    substituteInPlace config.mk \
      --replace '-lsodium -lopus -lvpx ' ""

    ${lib.optionalString (conf != null) "cp ${configFile} config.def.h"}
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "FIFO based tox client";
    mainProgram = "ratox";
    homepage = "http://ratox.2f30.org/";
    license = licenses.isc;
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux;
  };
}
