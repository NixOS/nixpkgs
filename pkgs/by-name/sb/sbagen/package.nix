{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "sbagen";
  version = "1.4.4";

  src = fetchurl {
    url = "https://uazu.net/sbagen/sbagen-${version}.tgz";
    sha256 = "0w62yk1b0hq79kl0angma897yqa8p1ww0dwydf3zlwav333prkd2";
  };

  postPatch = ''
    patchShebangs ./mk
  '';

  buildPhase = "./mk";

  installPhase = ''
    mkdir -p $out/{bin,share/sbagen/doc}
    cp -r --target-directory=$out/share/sbagen examples scripts river1.ogg river2.ogg
    cp sbagen $out/bin
    cp --target-directory=$out/share/sbagen/doc README.txt SBAGEN.txt theory{,2}.txt {wave,holosync,focus,TODO}.txt
  '';

  meta = {
    description = "Binaural sound generator";
    homepage = "http://uazu.net/sbagen";
    license = lib.licenses.gpl2;
    platforms = [ "i686-linux" ];
  };
}
