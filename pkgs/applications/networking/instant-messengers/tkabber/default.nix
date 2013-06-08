{ stdenv, fetchurl, tcl, tk, tcllib, tcltls, tclgpg
, bwidget, makeWrapper, x11 }:

let
  tclLibraries = [ bwidget tcllib tcltls tclgpg ];

  getTclLibPath = p: "${p}/lib/${p.libPrefix}";

  tclLibPaths = stdenv.lib.concatStringsSep " "
    (map getTclLibPath tclLibraries);

in stdenv.mkDerivation rec {
  name = "tkabber-0.11.1";

  src = fetchurl {
    url = "http://files.jabber.ru/tkabber/tkabber-0.11.1.tar.gz";
    sha256 = "19xv555cm7a2gczdalf9srxm39hmsh0fbidhwxa74a89nqkbf4lv";
  };

  defaultTheme = "ocean-deep";

  patchPhase = ''
    substituteInPlace login.tcl --replace \
      "custom::defvar loginconf(sslcacertstore) \"\"" \
      "custom::defvar loginconf(sslcacertstore) \$env(OPENSSL_X509_CERT_FILE)"

    sed -i '/^if.*load_default_xrdb/,/^}$/ {
        s@option readfile \(\[fullpath [^]]*\]\)@option readfile "'"$out/share/doc/tkabber/examples/xrdb/${defaultTheme}.xrdb"'"@
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
