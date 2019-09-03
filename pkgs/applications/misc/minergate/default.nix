{ fetchurl, stdenv, dpkg, makeWrapper, fontconfig, freetype, openssl, xorg, xkeyboard_config }:

stdenv.mkDerivation rec {
  version = "8.1";
  pname = "minergate";
  src = fetchurl {
    url = "https://minergate.com/download/ubuntu";
    sha256 = "1dbbbb8e0735cde239fca9e82c096dcc882f6cecda20bba7c14720a614c16e13";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    dpkg-deb -x $src $out
    pgm=$out/opt/minergate/minergate

    interpreter=${stdenv.glibc}/lib/ld-linux-x86-64.so.2
    patchelf --set-interpreter "$interpreter" $pgm

    wrapProgram $pgm --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ fontconfig freetype openssl stdenv.cc.cc xorg.libX11 xorg.libxcb ]} --prefix "QT_XKB_CONFIG_ROOT" ":" "${xkeyboard_config}/share/X11/xkb"

    rm $out/usr/bin/minergate
    mkdir -p $out/bin
    ln -s $out/opt/minergate/minergate $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Minergate CPU/GPU mining software";
    homepage = https://www.minergate.com/;
    license = licenses.unfree;
    maintainers = with maintainers; [ bfortz ];
    platforms = [ "x86_64-linux" ];
};
}
