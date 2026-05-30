{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  bc,
  findutils,
  flac,
  lame,
  opus-tools,
  procps,
  sox,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "caudec";
  version = "1.7.5";

  src = fetchurl {
    url = "http://caudec.cocatre.net/downloads/caudec-${finalAttrs.version}.tar.gz";
    sha256 = "5d1f5ab3286bb748bd29cbf45df2ad2faf5ed86070f90deccf71c60be832f3d5";
  };

  preBuild = ''
    patchShebangs ./install.sh
  '';

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    ./install.sh --prefix=$out/bin
  '';

  postFixup = ''
      for executable in $(cd $out/bin && ls); do
    wrapProgram $out/bin/$executable \
      --prefix PATH : "${
        lib.makeBinPath [
          bc
          findutils
          sox
          procps
          opus-tools
          lame
          flac
        ]
      }"
      done
  '';

  meta = {
    homepage = "https://caudec.cocatre.net/";
    description = "Multiprocess audio converter that supports many formats (FLAC, MP3, Ogg Vorbis, Windows codecs and many more)";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
