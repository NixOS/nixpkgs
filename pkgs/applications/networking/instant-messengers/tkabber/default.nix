{ stdenv, fetchurl, tcl, tk, tcllib, tcltls, tclgpg
, bwidget, makeWrapper, x11
, withSitePlugins ? true
, theme ? null
}:

with stdenv.lib;

let
  version = "1.0";

  main = {
    name = "tkabber";
    sha256 = "49ee6e897dfe52ebac256531b54955e6b39223f606a9b8ad63a52475389db206";
  };

  plugins = {
    name = "tkabber-plugins";
    sha256 = "d61251dc664f0bfa8534e578096dede9a7bb7d4f2620489f8d2c43d36cd61ba9";
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
  postPatch = ''
    substituteInPlace login.tcl --replace \
      "custom::defvar loginconf(sslcacertstore) \"\"" \
      "custom::defvar loginconf(sslcacertstore) \$env(OPENSSL_X509_CERT_FILE)"
  '' + optionalString (theme != null) ''
    themePath="$out/share/doc/tkabber/examples/xrdb/${theme}.xrdb"
    sed -i '/^if.*load_default_xrdb/,/^}$/ {
      s@option readfile \(\[fullpath [^]]*\]\)@option readfile "'"$themePath"'"@
    }' tkabber.tcl
  '';

  postInstall = ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" \
        --prefix PATH : "${tk}/bin" \
        --set TCLLIBPATH '"${tclLibPaths}"' \
        ${optionalString withSitePlugins ''
        --set TKABBER_SITE_PLUGINS '${mkTkabber plugins}/share/tkabber-plugins'
        ''}
    done
  '';

  buildInputs = [ tcl tk x11 makeWrapper ] ++ tclLibraries;

  meta = {
    homepage = "http://tkabber.jabber.ru/";
    description = "A GUI XMPP (Jabber) client written in Tcl/Tk";
    license = stdenv.lib.licenses.gpl2;
  };
})
