{ stdenv, fetchdarcs, ocaml, findlib, cryptokit, yojson, lmdb, zlib }:

stdenv.mkDerivation rec {
  name = "pijul-${version}";
  version = "0.1";

  src = fetchdarcs {
    url = "http://pijul.org/";
    rev = version;
    sha256 = "0r189xx900w4smq6nyy1wnrjf9sgqrqw5as0l7k6gq0ra36szzff";
  };

  buildInputs = [ ocaml findlib cryptokit yojson lmdb zlib ];

  installPhase = ''
    mkdir -p $out/bin
    cp pijul $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage = https://pijul.org/;
    description = "Fast DVCS based on a categorical theory of patches";
    license = licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with maintainers; [ puffnfresh ];
  };
}
