{ clangStdenv, fetchgit, llvm, clangUnwrapped }:

clangStdenv.mkDerivation {
  name = "emacs-clang-complete-async-git";
  src = fetchgit {
    url = "git://github.com/Golevka/emacs-clang-complete-async.git";
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

