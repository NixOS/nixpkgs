{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="mi2ly";
    version="0.12";
    name="${baseName}-${version}";
    hash="1b14zcwlvnxhjxr3ymyzg0mg4sbijkinzpxm641s859jxcgylmll";
    url="https://download.savannah.gnu.org/releases/mi2ly/mi2ly.0.12.tar.bz2";
    sha256="1b14zcwlvnxhjxr3ymyzg0mg4sbijkinzpxm641s859jxcgylmll";
  };
  buildInputs = [
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };

  sourceRoot=".";

  hardeningDisable = [ "format" ];

  buildPhase = "./cc";
  installPhase = ''
    mkdir -p "$out"/{bin,share/doc/mi2ly}
    cp mi2ly "$out/bin"
    cp README Doc.txt COPYING Manual.txt "$out/share/doc/mi2ly"
  '';

  meta = {
    inherit (s) version;
    description = ''MIDI to Lilypond converter'';
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    broken = true; # 2018-04-11
  };
}
