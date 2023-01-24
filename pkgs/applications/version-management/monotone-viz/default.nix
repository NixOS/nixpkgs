{ lib, stdenv, fetchurl, ocamlPackages, gnome2, pkg-config, makeWrapper, glib
, libtool, libpng, bison, expat, fontconfig, gd, pango, libjpeg, libwebp, libX11, libXaw
}:
# We need an old version of Graphviz for format compatibility reasons.
# This version is vulnerable, but monotone-viz will never feed it bad input.
let graphviz_2_0 = import ./graphviz-2.0.nix {
      inherit lib stdenv fetchurl pkg-config libX11 libpng libjpeg expat libXaw
        bison libtool fontconfig pango gd libwebp;
    }; in
let inherit (gnome2) libgnomecanvas; in
let inherit (ocamlPackages) ocaml lablgtk camlp4; in
stdenv.mkDerivation rec {
  version = "1.0.2";
  pname = "monotone-viz";

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ocaml lablgtk libgnomecanvas glib graphviz_2_0 camlp4];
  src = fetchurl {
    url = "http://oandrieu.nerim.net/monotone-viz/${pname}-${version}-nolablgtk.tar.gz";
    sha256 = "1l5x4xqz5g1aaqbc1x80mg0yzkiah9ma9k9mivmn08alkjlakkdk";
  };

  prePatch="ln -s . a; ln -s . b";
  patchFlags = ["-p0"];
  patches = [
    (fetchurl {
      url = "https://src.fedoraproject.org/cgit/rpms/monotone-viz.git/plain/monotone-viz-1.0.2-dot.patch";
      sha256 = "0risfy8iqmkr209hmnvpv57ywbd3rvchzzd0jy2lfyqrrrm6zknw";
    })
    (fetchurl {
      url = "https://src.fedoraproject.org/cgit/rpms/monotone-viz.git/plain/monotone-viz-1.0.2-new-stdio.patch";
      sha256 = "16bj0ppzqd45an154dr7sifjra7lv4m9anxfw3c56y763jq7fafa";
    })
    (fetchurl {
      url = "https://src.fedoraproject.org/cgit/rpms/monotone-viz.git/plain/monotone-viz-1.0.2-typefix.patch";
      sha256 = "1gfp82rc7pawb5x4hh2wf7xh1l1l54ib75930xgd1y437la4703r";
    })
  ];

  preConfigure = ''
    configureFlags="$configureFlags --with-lablgtk-dir=$(echo ${lablgtk}/lib/ocaml/*/site-lib/lablgtk2)"
  '';

  postInstall = ''
    wrapProgram "$out/bin/monotone-viz" --prefix PATH : "${graphviz_2_0}/bin/"
  '';

  meta = {
    description = "Monotone ancestry visualiser";
    license = lib.licenses.gpl2Plus ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
  };
}
