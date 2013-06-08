{ clangStdenv, fetchgit, llvm, clangUnwrapped }:

clangStdenv.mkDerivation {
  name = "emacs-clang-complete-async-20130218";
  src = fetchgit {
    url = "git://github.com/Golevka/emacs-clang-complete-async.git";
    rev = "f01488971ec8b5752780d130fb84de0c16a46f31";
    sha256 = "1c8zqi6axbsb951azz9iqx3j52j30nd9ypv396hvids3g02cirrf";
  };

  buildInputs = [ llvm clangUnwrapped ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/emacs/site-lisp
    install -m 755 clang-complete $out/bin
    install -m 644 auto-complete-clang-async.el $out/share/emacs/site-lisp
  '';

  meta = {
    homepage = "https://github.com/Golevka/emacs-clang-complete-async";
    description = "An emacs plugin to complete C and C++ code using libclang";
    license = "GPLv3+";
  };
}

