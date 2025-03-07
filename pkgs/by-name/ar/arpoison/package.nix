{
  lib,
  stdenv,
  fetchzip,
  libnet,
}:

stdenv.mkDerivation rec {
  pname = "arpoison";
  version = "0.7";

  buildInputs = [ libnet ];

  src = fetchzip {
    url = "http://www.arpoison.net/arpoison-${version}.tar.gz";
    sha256 = "0krhszx3s0qwfg4rma5a51ak71nnd9xfs2ibggc3hwiz506s2x37";
  };

  postPatch = "substituteInPlace Makefile --replace gcc cc";

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man8
    gzip arpoison.8
    cp arpoison $out/bin
    cp arpoison.8.gz $out/share/man/man8
  '';

  meta = with lib; {
    description = "UNIX arp cache update utility";
    homepage = "http://www.arpoison.net/";
    license = with licenses; [ gpl2Only ];
    maintainers = [ maintainers.michalrus ];
    platforms = platforms.unix;
    mainProgram = "arpoison";
  };
}
