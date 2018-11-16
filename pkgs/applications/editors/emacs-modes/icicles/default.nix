{ stdenv, fetchurl, emacs }:

let
  modules = [
    { name = "icicles.el"; sha256 = "0wxak7wh0rrb3h77ay2vypbb53skcfbrv71xkajhax0w12q6zpaj"; }
    { name = "icicles-chg.el"; sha256 = "0qavq9vy566l3qi9n8akrqjcgy8n6k0j8d7vsc7p1jhqvvq812gh"; }
    { name = "icicles-cmd1.el"; sha256 = "0lgk6ngl9090iqvvw1c227q7p37mr73cc6ap3ky6b0nv3ql8rkyi"; }
    { name = "icicles-cmd2.el"; sha256 = "15swxk7fr7wsqpf26xzbvyk12ikkvfcyh9w8wmnpc38dmpyq79rb"; }
    { name = "icicles-doc1.el"; sha256 = "04j5qvj7pqnjh8h2y2sdgi7x55czdp9xn7yysr3bzcmr1rq5p4bz"; }
    { name = "icicles-doc2.el"; sha256 = "1k8vfhi3fa4bzsxr074bw5q6srvq6z6hi61rzlxdw7pah6qf7hcz"; }
    { name = "icicles-face.el"; sha256 = "1pvygqzmh6ag0zhfjn1vhdvlhxybwxzj22ah2pc0ls80dlywhi4l"; }
    { name = "icicles-fn.el"; sha256 = "05v7sc2k2mjm1mbnlkpi01aaxnxnb40540y7g70dg534scjd7w36"; }
    { name = "icicles-mac.el"; sha256 = "0nhbwswz6xz7q4g8flszgx12q4gi4nx1d3n4jgz6svr2kk2vmlb4"; }
    { name = "icicles-mcmd.el"; sha256 = "05dniz6337v9r15w8r2zad0n2h6jlygzjp7vw75vvq8mds0acmia"; }
    { name = "icicles-mode.el"; sha256 = "1xfv8nryf5y2gygg02naawzm5qhrkba3h84g43518r1xc6rgbpp6"; }
    { name = "icicles-opt.el"; sha256 = "10n4p999ylkapirs75y5fh33lpiyx42i3ajzl2zjfwyr1zksg1iz"; }
    { name = "icicles-var.el"; sha256 = "1r5gb01zg8nf2qryq9saxfpnzlymmppsk7w1g09lac35c87vh8yl"; }
  ];

  forAll = f: map f modules;
in
stdenv.mkDerivation rec {
  version = "2018-07-02";
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
