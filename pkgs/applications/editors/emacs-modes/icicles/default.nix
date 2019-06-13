{ stdenv, fetchurl, emacs }:

let
  modules = [
    { name = "icicles.el"; sha256 = "1744n5g2kmv3r261ipa0fhrgnapl0chxz57bbbls3bp30cnnfrs7"; }
    { name = "icicles-chg.el"; sha256 = "058sxa8wh3vqr3zy677q6m2lfx4n477rnb8921s1p6wgs55v7dp4"; }
    { name = "icicles-cmd1.el"; sha256 = "064hyy8nxvlg298s5qnmk7aczbasfpddhx57jxaldyyzkca3n2h5"; }
    { name = "icicles-cmd2.el"; sha256 = "0a77fx0pxyfrg9nxvqvzz247v6cljjfz9dnfs7lc8qgdvksxs261"; }
    { name = "icicles-doc1.el"; sha256 = "04j5qvj7pqnjh8h2y2sdgi7x55czdp9xn7yysr3bzcmr1rq5p4bz"; }
    { name = "icicles-doc2.el"; sha256 = "1k8vfhi3fa4bzsxr074bw5q6srvq6z6hi61rzlxdw7pah6qf7hcz"; }
    { name = "icicles-face.el"; sha256 = "1pvygqzmh6ag0zhfjn1vhdvlhxybwxzj22ah2pc0ls80dlywhi4l"; }
    { name = "icicles-fn.el"; sha256 = "02vwa9dx9393d7kxrf443r1lj7y9ihkh25cmd418pwfgmw2yd5s7"; }
    { name = "icicles-mac.el"; sha256 = "13nxgg9k5w39lga90jwn1c7v756dqlfln2qh312vfaxfjfijfv9r"; }
    { name = "icicles-mcmd.el"; sha256 = "17d4zlf3r09wmarwyc1cbjv0pyklg4cdhwh3h643d4v8mhs5hnil"; }
    { name = "icicles-mode.el"; sha256 = "1xfv8nryf5y2gygg02naawzm5qhrkba3h84g43518r1xc6rgbpp6"; }
    { name = "icicles-opt.el"; sha256 = "154mgcd1ksnmlyb4ijy2njqq75i8cj4k47phplxsi648pzqnda77"; }
    { name = "icicles-var.el"; sha256 = "0f94299q1z0va4v1s5ijpksaqlaz88ay1qbmlzq0i2wnxnsliys8"; }
  ];

  forAll = f: map f modules;
in
stdenv.mkDerivation rec {
  version = "2019-02-22";
  name = "icicles-${version}";

  srcs = forAll ({name, sha256}: fetchurl { url = "https://www.emacswiki.org/emacs/download/${name}"; inherit sha256; });

  buildInputs = [ emacs ];

  unpackPhase = "for m in $srcs; do cp $m $(echo $m | cut -d- -f2-); done";

  buildPhase = "emacs --batch -L . -f batch-byte-compile *.el";

  installPhase = "mkdir -p $out/share/emacs/site-lisp/emacswiki/${name}/; cp *.el *.elc $out/share/emacs/site-lisp/emacswiki/${name}/";

  meta = {
    homepage = https://www.emacswiki.org/emacs/Icicles;
    description = "Enhance Emacs minibuffer input with cycling and powerful completion";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms   = emacs.meta.platforms;
    maintainers = with stdenv.lib.maintainers; [ scolobb ];
  };
}
