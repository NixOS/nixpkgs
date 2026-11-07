{
  stdenv,
  fetchurl,
  mecab,
  lib,
}:

stdenv.mkDerivation rec {
  name = "mecab-ko-dic";
  version = "2.1.1-20180720";

  src = fetchurl {
    url = "https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-${version}.tar.gz";
    hash = "sha256-/WLT1tj6hRRVKAZfq61NfLIPayIB5xvkCBpOlwGlszA=";
  };

  buildInputs = [ mecab ];

  configureFlags = [
    "--with-charset=utf8"
    "--with-dicdir=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Dictionary files for Mecab-ko (a morphological analyis system)";
    homepage = "https://bitbucket.org/eunjeon/mecab-ko-dic";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ samdroid-apps ];
  };
}
