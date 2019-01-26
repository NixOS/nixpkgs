{ fetchurl, stdenv, dpkg, makeWrapper, openssl }:

stdenv.mkDerivation rec {
  version = "8.2";
  name = "minergate-cli-${version}";
  src = fetchurl {
    url = "https://minergate.com/download/ubuntu-cli";
    sha256 = "393c5ba236f6f92c449496fcda9509f4bfd3887422df98ffa59b3072124a99d8";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    dpkg-deb -x $src $out
    pgm=$out/opt/minergate-cli/minergate-cli

    interpreter=${stdenv.glibc}/lib/ld-linux-x86-64.so.2
    patchelf --set-interpreter "$interpreter" $pgm

    wrapProgram $pgm --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ openssl stdenv.cc.cc ]} 

    rm $out/usr/bin/minergate-cli
    mkdir -p $out/bin
    ln -s $pgm $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Minergate CPU/GPU console client mining software";
    homepage = https://www.minergate.com/;
    license = licenses.unfree;
    maintainers = with maintainers; [ bfortz ];
    platforms = [ "x86_64-linux" ];
};
}
