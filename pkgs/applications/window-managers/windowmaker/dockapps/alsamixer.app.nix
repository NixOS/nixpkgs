{ stdenv, fetchgit, pkgconfig, libX11, libXpm, libXext, alsaLib }:

stdenv.mkDerivation {
  name = "alsamixer.app-0.2.1";
  src = fetchgit {
     url = git://repo.or.cz/dockapps.git;
     rev = "38c74350b02f35824554ce0c4f0f251d71762040";
     sha256 = "0g9cwhlqg065fbhav4g4n16a4cqkk9jykl3y0zwbn5whhacfqyhl";
  };

  buildInputs = [ pkgconfig libX11 libXpm libXext alsaLib ];

  postUnpack = "sourceRoot=\${sourceRoot}/AlsaMixer.app";

  installPhase = ''
    mkdir -pv $out/bin;
    cp AlsaMixer.app $out/bin/AlsaMixer;
    '';

  meta = {
    description = "Alsa mixer application for Windowmaker";
    homepage = http://windowmaker.org/dockapps/?name=AlsaMixer.app;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.bstrik ];
  };
}
