{ stdenv, fetchgit, cmake, boost }:

let
  rev = "ec8b5663086ecf81e54965418b80321429f1a53b";
  date = "20140528";
in
stdenv.mkDerivation {
  name = "bitmonero-${date}-${stdenv.lib.strings.substring 0 7 rev}";

  src = fetchgit {
    url = https://github.com/bitmonero-project/bitmonero.git;
    inherit rev;
    sha256 = "242c1d28acca8ffa03255dbfc9eb9665bdbae4ab12639af935f9d787a880ba91";
  };

  buildInputs = [ cmake boost ];

  installPhase = ''
    mkdir -p $out/bin
    cp src/bitmonerod src/connectivity_tool src/simpleminer src/simplewallet $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = http://monero.cc/;
    maintainers = [ maintainers.emery ];
  };
}