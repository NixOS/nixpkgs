{ stdenv, fetchurl, tcl, tk, tcllib, tcltls, tclgpg
, bwidget, makeWrapper, xlibsWrapper
, withSitePlugins ? true
, theme ? null
}:

with stdenv.lib;

let
  version = "1.1";

  main = {
    name = "tkabber";
    sha256 = "1ip0mi2icqkjxiam4qj1qcynnz9ck1ggzcbcqyjj132hakd855a2";
  };

  plugins = {
    name = "tkabber-plugins";
    sha256 = "1dr12rh4vs1w1bga45k4ijgxs39801c1k4z3b892pn1dwv84il5y";
  };

  tclLibraries = [ bwidget tcllib tcltls tclgpg ];

  getTclLibPath = p: "${p}/lib/${p.libPrefix}";

  tclLibPaths = stdenv.lib.concatStringsSep " "
    (map getTclLibPath tclLibraries);

  mkTkabber = attrs: stdenv.mkDerivation (rec {
    name = "${attrs.name}-${version}";

    src = fetchurl {
      url = "http://files.jabber.ru/tkabber/${name}.tar.xz";
      inherit (attrs) sha256;
    };

    prePatch = ''
      sed -e "s@/usr/local@$out@" -i Makefile
    '';
  } // removeAttrs attrs [ "name" "sha256" ]);

in mkTkabber (main // {
  postPatch = optionalString (theme != null) ''
    themePath="$out/share/doc/tkabber/examples/xrdb/${theme}.xrdb"
    sed -i '/^if.*load_default_xrdb/,/^}$/ {
      s@option readfile \(\[fullpath [^]]*\]\)@option readfile "'"$themePath"'"@
    }' tkabber.tcl
  '';

  postInstall = ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" \
        --prefix PATH : "${tk}/bin" \
        --set TCLLIBPATH '${tclLibPaths}' \
        ${optionalString withSitePlugins ''
        --set TKABBER_SITE_PLUGINS '${mkTkabber plugins}/share/tkabber-plugins'
        ''}
    done
  '';

  buildInputs = [ tcl tk xlibsWrapper makeWrapper ] ++ tclLibraries;

  meta = {
    homepage = "http://tkabber.jabber.ru/";
    description = "A GUI XMPP (Jabber) client written in Tcl/Tk";
    license = stdenv.lib.licenses.gpl2;
  };
})
