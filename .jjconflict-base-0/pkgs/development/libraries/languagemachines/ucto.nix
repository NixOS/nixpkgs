{
  lib,
  stdenv,
  fetchurl,
  automake,
  autoconf,
  libtool,
  pkg-config,
  autoconf-archive,
  libxml2,
  icu,
  bzip2,
  libtar,
  languageMachines,
}:

let
  release = lib.importJSON ./release-info/LanguageMachines-ucto.json;
in

stdenv.mkDerivation {
  pname = "ucto";
  version = release.version;
  src = fetchurl {
    inherit (release) url sha256;
    name = "ucto-${release.version}.tar.gz";
  };
  nativeBuildInputs = [
    pkg-config
    automake
    autoconf
  ];
  buildInputs = [
    bzip2
    libtool
    autoconf-archive
    icu
    libtar
    libxml2
    languageMachines.ticcutils
    languageMachines.libfolia
    languageMachines.uctodata
    # TODO textcat from libreoffice? Pulls in X11 dependencies?
  ];
  preConfigure = "sh bootstrap.sh;";

  postInstall = ''
    # ucto expects the data files installed in the same prefix
    mkdir -p $out/share/ucto/;
    for f in ${languageMachines.uctodata}/share/ucto/*; do
      echo "Linking $f"
      ln -s $f $out/share/ucto/;
    done;
  '';

  meta = with lib; {
    description = "Rule-based tokenizer for natural language";
    mainProgram = "ucto";
    homepage = "https://languagemachines.github.io/ucto/";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ roberth ];

    longDescription = ''
      Ucto tokenizes text files: it separates words from punctuation, and splits sentences. It offers several other basic preprocessing steps such as changing case that you can all use to make your text suited for further processing such as indexing, part-of-speech tagging, or machine translation.

      Ucto comes with tokenisation rules for several languages and can be easily extended to suit other languages. It has been incorporated for tokenizing Dutch text in Frog, a Dutch morpho-syntactic processor.
    '';
  };

}
