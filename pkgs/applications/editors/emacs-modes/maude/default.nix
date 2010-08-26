{stdenv, fetchurl, emacs}:

stdenv.mkDerivation rec {
  name = "maude-mode-2.0";

  src = fetchurl   {
    url = "http://maude.cs.uiuc.edu/download/maude-mode2.el";
    sha256 = "0lq5p820pgky8i32005v91g0v9va9jwkv1jr6y4n8zc7bz1gyws6";
  };

  buildInputs = [/* emacs */];

  buildCommand = ''
    ensureDir "$out/share/emacs/site-lisp"
    substitute "${src}" "$out/share/emacs/site-lisp/maude-mode.el" --replace "/local/bin/maude" "maude"
  '';

  meta = {
    description = "Emacs mode for the programming language Maude";
    license = "GPLv2";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
