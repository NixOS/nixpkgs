{
  stdenv,
  fetchFromBitbucket,
  mecab-ko-dic,
  lib,
}:

stdenv.mkDerivation rec {
  name = "mecab-ko";
  version = "0.9.2";

  src = (
    fetchFromBitbucket {
      owner = "eunjeon";
      repo = "mecab-ko";
      rev = "release-${version}";
      hash = "sha256-vZ7qQi/k5OXlaFSasKNF+I6VrWjvmqbq+A1tDFSww0w=";
    }
  );

  postInstall = ''
    mkdir -p $out/lib/mecab/dic
    ln -s ${mecab-ko-dic} $out/lib/mecab/dic/mecab-ko-dic
  '';

  configureFlags = [ "--with-charset=utf8" ];

  # mecab-ko uses several features that have been removed in C++17.
  # Force the language mode to C++14, so that it can compile.
  makeFlags = [ "CXXFLAGS=-std=c++14" ];

  doCheck = true;

  meta = with lib; {
    description = "A Korean morphological analyzer";
    homepage = "https://bitbucket.org/eunjeon/mecab-ko";
    license = with licenses; [
      gpl2Only
      lgpl21Only
      bsd3
    ];
    platforms = platforms.unix;
    mainProgram = "mecab";
    maintainers = with maintainers; [ samdroid-apps ];
  };
}
