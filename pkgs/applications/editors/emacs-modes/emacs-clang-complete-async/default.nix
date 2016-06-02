{ clangStdenv, fetchgit, llvmPackages, clang }:

clangStdenv.mkDerivation {
  name = "emacs-clang-complete-async-20130218";
  src = fetchgit {
    url = "git://github.com/Golevka/emacs-clang-complete-async.git";
    rev = "f01488971ec8b5752780d130fb84de0c16a46f31";
    sha256 = "01smjinrvx0w5z847a43fh2hyr6rrq1kaglfakbr6dcr313w89x9";
  };

  buildInputs = [ llvmPackages.llvm ];

  patches = [ ./fix-build.patch ];

  CFLAGS = "-I${llvmPackages.clang}/include";
  LDFLAGS = "-L${llvmPackages.clang}/lib";

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/emacs/site-lisp
    install -m 755 clang-complete $out/bin
    install -m 644 auto-complete-clang-async.el $out/share/emacs/site-lisp
  '';

  meta = {
    homepage = "https://github.com/Golevka/emacs-clang-complete-async";
    description = "An emacs plugin to complete C and C++ code using libclang";
    license = clangStdenv.lib.licenses.gpl3Plus;
  };
}
