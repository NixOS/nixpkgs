{lib, stdenv, fetchurl, fetchpatch, gtk2, perlPackages, pkg-config } :

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
  patches = (if stdenv.hostPlatform.system == "x86_64-linux" then
        [ ./gcolor2-amd64.patch ] else
        [ ])
   ++ [
     # Pull patch pending upstream inclusion for -fno-common toolchains:
     #   https://sourceforge.net/p/gcolor2/patches/8/
     (fetchpatch {
       name = "fno-common.patch";
       url = "https://sourceforge.net/p/gcolor2/patches/8/attachment/0001-gcolor2-fix-build-on-gcc-10-fno-common.patch";
       sha256 = "0187zc8as9g3d6mpm3isg87jfpryj0hajb4inwvii8gxrzbi5l5f";
     })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 ]
    ++ (with perlPackages; [ perl XMLParser ]);

  meta = {
    description = "Simple GTK 2 color selector";
    homepage = "https://gcolor2.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ notthemessiah ];
    platforms = with lib.platforms; unix;
  };
}
