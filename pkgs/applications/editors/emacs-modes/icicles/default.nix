{ stdenv, fetchurl, emacs }:

let
  modules = [
    { name = "icicles.el"; sha256 = "175g8w620vy73pp3zyasfjspgljk6g0lki71kdnvw5z88w3s9d1n"; }
    { name = "icicles-chg.el"; sha256 = "1bx5xdhirvnrjqk4pk0sjp9bpj1syymsjnckklsw04gv6y0x8zik"; }
    { name = "icicles-cmd1.el"; sha256 = "1ff0mndin9zxrswwwq3a7b1s879rr6gy8rzxanr7kxg1ppciafad"; }
    { name = "icicles-cmd2.el"; sha256 = "1a44l86jacp9nsy4z260azz6y672drjw3w5a0jsc8w26fgsrnx1k"; }
    { name = "icicles-doc1.el"; sha256 = "0s3r4z3y06hd1nxp18wd0b8b88z2a7ryy0j8sx5fzibbmp58ars1"; }
    { name = "icicles-doc2.el"; sha256 = "0c10jg91qxyrg1zwiyi4m57dbw3yf43jdrpi4nnby3pkzh6i37ic"; }
    { name = "icicles-face.el"; sha256 = "0n0vcbhwgd2lyj7anq1zpwja28xry018qxbm8sprxkh6y3vlw8d2"; }
    { name = "icicles-fn.el"; sha256 = "1i10593a7hp465bxd86h7h7gwrdyqxx0d13in53z4jnab8icp3d4"; }
    { name = "icicles-mac.el"; sha256 = "1piq0jk8nz0hz9wwci7dkxnfxscdpygjzpj5zg3310vs22l7rrsz"; }
    { name = "icicles-mcmd.el"; sha256 = "0c4325yp84i46605nlxmjm6n0f4fh69shsihvd0wb9ryg0a8qa65"; }
    { name = "icicles-mode.el"; sha256 = "069wx5clqpsq2c9aavgd9xihvlad3g00iwwrc3cpl47v64dvlipq"; }
    { name = "icicles-opt.el"; sha256 = "16487l3361ca8l6il2c0z892843sc5l9v4gr7lx5fxbmrlsswvvn"; }
    { name = "icicles-var.el"; sha256 = "1a9cwxpi10x44fngxa7qnrg8hqfvdjb8s8k47gnn1rbh63blkkry"; }
  ];

  forAll = f: map f modules;
in
stdenv.mkDerivation {
  name = "icicles-2014-11-06";

  srcs = forAll ({name, sha256}: fetchurl { url = "http://www.emacswiki.org/emacs-en/download/${name}"; inherit sha256; });

  buildInputs = [ emacs ];

  unpackPhase = "for m in $srcs; do cp $m $(echo $m | cut -d- -f2-); done";

  buildPhase = "emacs --batch -L . -f batch-byte-compile *.el";

  installPhase = "mkdir -p $out/share/emacs/site-lisp; cp *.el *.elc $out/share/emacs/site-lisp/";

  meta = {
    homepage = "http://www.emacswiki.org/emacs/Icicles";
    description = "Enhance Emacs minibuffer input with cycling and powerful completion";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
