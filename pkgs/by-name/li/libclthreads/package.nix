{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libclthreads";
  version = "2.4.2";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/clthreads-${version}.tar.bz2";
    sha256 = "0cbs1w89q8wfjrrhvxf6xk0y02nkjl5hd0yb692c8ma01i6b2nf6";
  };

  patchPhase = ''
    cd source
    # don't run ldconfig:
    sed -e "/ldconfig/d" -i ./Makefile
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX=''"
  ];

  preInstall = ''
    # The Makefile does not create the include and lib directories
    mkdir -p $out/include
    mkdir -p $out/lib
  '';

  postInstall = ''
    ln $out/lib/libclthreads.so $out/lib/libclthreads.so.2
  '';

  meta = with lib; {
    description = "Zita thread library";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/index.html";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux;
  };
}
