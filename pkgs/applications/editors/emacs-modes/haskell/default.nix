{ stdenv, fetchurl, emacs, texinfo }:

let
  version = "13.10";
in
stdenv.mkDerivation {
  name = "haskell-mode-${version}";

  src = fetchurl {
    url = "https://github.com/haskell/haskell-mode/archive/v${version}.tar.gz";
    sha256 = "0hcg7wpalcdw8j36m8vd854zrrgym074r7m903rpwfrhx9mlg02b";
  };

  buildInputs = [ emacs texinfo ];

  makeFlags = "VERSION=${version} GIT_VERSION=${version}";

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    cp *.el *.elc *.hs $out/share/emacs/site-lisp/
    mkdir -p $out/share/info
    cp -v *.info* $out/share/info/
  '';

  meta = {
    homepage = "http://github.com/haskell/haskell-mode";
    description = "Haskell mode for Emacs";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
