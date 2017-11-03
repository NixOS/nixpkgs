{ stdenv, fetchurl, emacs }:

let
  modules = [
    { name = "icicles.el"; sha256 = "10w1lghh9jqxxm5cszi2qyk24vnvazfywmyyz1v7zf6cyiwbndrz"; }
    { name = "icicles-chg.el"; sha256 = "020yg4hv120mcy7qvn76j85q6hl7mfcfv66w55c6izc9lbrvvnv8"; }
    { name = "icicles-cmd1.el"; sha256 = "1715x1vkiax93890gfjbzslxsn4swsv37spvyx7chy4s1mym9kfw"; }
    { name = "icicles-cmd2.el"; sha256 = "187k0gmn34fn6w1dw9hjf4i788y01vk47z7ac11ar4bddwh97ddx"; }
    { name = "icicles-doc1.el"; sha256 = "1bw5dkymn2xdrfrp80am0gqi0szs0xihny4qmgzgx6hfbng351qh"; }
    { name = "icicles-doc2.el"; sha256 = "0zd94m1a8mwwbrbcrahxxx8q34w8cg5lna4yww4m1gliyklww86s"; }
    { name = "icicles-face.el"; sha256 = "1mlz8dq7bgzp2cf5j37i25yw90ry657d2m8r93rdj67h7l4wyxhj"; }
    { name = "icicles-fn.el"; sha256 = "1cdghvgsr0b7pdq4lmnfm6kwwcqbk4wqf168kf2sjajbpa24ix96"; }
    { name = "icicles-mac.el"; sha256 = "1w5sgzbp8hyjzrmqd8bwivszaayzh8dkyqa0d751adiwjfs9sq9m"; }
    { name = "icicles-mcmd.el"; sha256 = "1lf2galn3g52hfz61avlr4ifyn5b42dfbmyq78cpzlq7hzc928v2"; }
    { name = "icicles-mode.el"; sha256 = "0gci04j6vx0vqsh4skarznklam1xibj7pjvy67kaip8b6a4zx9ip"; }
    { name = "icicles-opt.el"; sha256 = "17g35ancml0mvywagzhjrgmlr4rhm1wgb5wg3fsqhhldib9qlz56"; }
    { name = "icicles-var.el"; sha256 = "0ydixg41h09yncp8g2nv8zsyv8avg1hj2f3mgrmd2kf0n27bw2nv"; }
  ];

  forAll = f: map f modules;
in
stdenv.mkDerivation rec {
  version = "2017-10-28";
  name = "icicles-${version}";

  srcs = forAll ({name, sha256}: fetchurl { url = "http://www.emacswiki.org/emacs/download/${name}"; inherit sha256; });

  buildInputs = [ emacs ];

  unpackPhase = "for m in $srcs; do cp $m $(echo $m | cut -d- -f2-); done";

  buildPhase = "emacs --batch -L . -f batch-byte-compile *.el";

  installPhase = "mkdir -p $out/share/emacs/site-lisp/emacswiki/${name}/; cp *.el *.elc $out/share/emacs/site-lisp/emacswiki/${name}/";

  meta = {
    homepage = http://www.emacswiki.org/emacs/Icicles;
    description = "Enhance Emacs minibuffer input with cycling and powerful completion";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms   = emacs.meta.platforms;
    maintainers = with stdenv.lib.maintainers; [ scolobb ];
  };
}
