{stdenv, fetchurl, gtk2, perlPackages, pkgconfig } :

let version = "0.4"; in
stdenv.mkDerivation {
  pname = "gcolor2";
  inherit version;
  arch = if stdenv.hostPlatform.system == "x86_64-linux" then "amd64" else "386";

  src = fetchurl {
    url = "mirror://sourceforge/project/gcolor2/gcolor2/${version}/gcolor2-${version}.tar.bz2";
    sha256 = "1siv54vwx9dbfcflklvf7pkp5lk6h3nn63flg6jzifz9wp0c84q6";
  };

  preConfigure = ''
    sed -i 's/\[:space:\]/[&]/g' configure
  '';

  # from https://github.com/PhantomX/slackbuilds/tree/master/gcolor2/patches
  patches = if stdenv.hostPlatform.system == "x86_64-linux" then
        [ ./gcolor2-amd64.patch ] else
        [ ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 ]
    ++ (with perlPackages; [ perl XMLParser ]);

  meta = {
    description = "Simple GTK 2 color selector";
    homepage = http://gcolor2.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ notthemessiah ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
