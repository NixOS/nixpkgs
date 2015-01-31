{ stdenv, fetchFromGitHub, emacs, texinfo }:

let
  version = "13.10-361-gfa09425";      # git describe --tags
in
stdenv.mkDerivation {
  name = "haskell-mode-${version}";

  src = fetchFromGitHub {
    owner = "haskell";
    repo = "haskell-mode";
    rev = "v${version}";
    sha256 = "1bq4gddzwjy2w1hbsmwxcamcy87amz7ksy1vmpwg0qij88fk4av9";
  };

  buildInputs = [ emacs texinfo ];

  makeFlags = "VERSION=v${version} GIT_VERSION=v${version}";

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    cp *.el *.elc *.hs $out/share/emacs/site-lisp/
    mkdir -p $out/share/info
    cp -v *.info* $out/share/info/
  '';

  # The test suite must run *after* copying the generated files to $out
  # because "make check" implies "make clean".
  doInstallCheck = true;
  installCheckTarget = "check";

  meta = {
    homepage = "http://github.com/haskell/haskell-mode";
    description = "Haskell mode for Emacs";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
