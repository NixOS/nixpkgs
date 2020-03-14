{ stdenv, fetchurl, sndio, libbsd }:

stdenv.mkDerivation rec {
  pname = "aucatctl";
  version = "0.1";
  src = fetchurl {
    url = "http://www.sndio.org/${pname}-${version}.tar.gz";
    sha256 = "524f2fae47db785234f166551520d9605b9a27551ca438bd807e3509ce246cf0";
  };

  buildInputs = [ sndio ] ++ stdenv.lib.optionals stdenv.isLinux [ libbsd ];

  outputs = [ "out" "man" ];

  prePatch = stdenv.lib.optionalString stdenv.isLinux ''
    # Required patching to build on Linux.
    substituteInPlace Makefile \
      --replace '-lsndio' '-lsndio -lbsd' \
      --replace '/usr/local' '${placeholder "out"}'

    # Fix warning about implicit declaration of function 'strlcpy'
    substituteInPlace aucatctl.c \
      --replace '#include <string.h>' '#include <bsd/string.h>'
  '';

  postInstall = ''
    moveToOutput share/man $man
  '';

  meta = with stdenv.lib; {
    description = "The aucatctl utility sends MIDI messages to control sndiod and/or aucat volumes";
    homepage = http://www.sndio.org;
    license = licenses.isc;
    maintainers = with maintainers; [ sna ];
    platforms = platforms.unix;
  };
}
