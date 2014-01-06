{ stdenv, fetchurl, tcl, tk, tcllib, tcltls, tclgpg
, bwidget, makeWrapper, x11
, theme ? null
}:

let
  tclLibraries = [ bwidget tcllib tcltls tclgpg ];

  getTclLibPath = p: "${p}/lib/${p.libPrefix}";

  tclLibPaths = stdenv.lib.concatStringsSep " "
    (map getTclLibPath tclLibraries);

in stdenv.mkDerivation rec {
  name = "tkabber-1.0";

  src = fetchurl {
    url = "http://files.jabber.ru/tkabber/${name}.tar.xz";
    sha256 = "49ee6e897dfe52ebac256531b54955e6b39223f606a9b8ad63a52475389db206";
  };

  patchPhase = ''
    substituteInPlace login.tcl --replace \
      "custom::defvar loginconf(sslcacertstore) \"\"" \
      "custom::defvar loginconf(sslcacertstore) \$env(OPENSSL_X509_CERT_FILE)"
  '' + stdenv.lib.optionalString (theme != null) ''
    themePath="$out/share/doc/tkabber/examples/xrdb/${theme}.xrdb"
    sed -i '/^if.*load_default_xrdb/,/^}$/ {
      s@option readfile \(\[fullpath [^]]*\]\)@option readfile "'"$themePath"'"@
    }' tkabber.tcl
  '';

  configurePhase = ''
    mkdir -p $out/bin
    sed -e "s@/usr/local@$out@" -i Makefile
  '';

  postInstall = ''
    wrapProgram $out/bin/tkabber \
      --prefix PATH : "${tk}/bin" \
      --set TCLLIBPATH '"${tclLibPaths}"' \
      --set TKABBER_SITE_PLUGINS '$HOME/.nix-profile/share/tkabber-plugins'
  '';

  buildInputs = [ tcl tk x11 makeWrapper ] ++ tclLibraries;

  meta = {
    homepage = "http://tkabber.jabber.ru/";
    description = "A GUI client for the XMPP (Jabber) instant messaging protocol";
    license = stdenv.lib.licenses.gpl2;
  };
}
