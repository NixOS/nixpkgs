{ stdenv, fetchurl, maxima, wxGTK }:

let
    name    = "wxmaxima";
    version = "0.8.3";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/wxMaxima-${version}.tar.gz";
    sha256 = "829e732e668f13c3153cc2fb67c7678973bf1bc468fb1b9f437fd0c24f59507a";
  };

  buildInputs = [maxima wxGTK];

  meta = {
    description = "wxWidgets GUI for the computer algebra system Maxima";
    homepage = http://wxmaxima.sourceforge.net;
  };
}

# # $Id: PKGBUILD,v 1.10 2008/05/13 19:03:39 ronald Exp $
# # Maintainer: Ronald van Haren <ronald.archlinux.org>
# # Contributor: Angelo Theodorou <encelo@users.sourceforge.net>
# # Contributor: Vinay S Shastry <vinayshastry@gmail.com>

# pkgname=wxmaxima
# pkgver=0.8.3
# pkgrel=1
# pkgdesc="A
# arch=('i686' 'x86_64')
# url="http://wxmaxima.sourceforge.net/"
# license=('GPL2')
# depends=('maxima>=5.18.1' 'libxml2>=2.7.3' 'wxgtk>=2.8.10.1')
# source=(http://downloads.sourceforge.net/$pkgname/wxMaxima-$pkgver.tar.gz)
# md5sums=('341913b9d54f24b796a50a3167b4d9b2')

# build() {
#   cd "${srcdir}/wxMaxima-${pkgver}"
#   ./configure --prefix=/usr || return 1
#   make || return 1
#   make DESTDIR="${pkgdir}" install || return 1

#   # Fix category in .desktop file
#   sed -i -e 's/Utility;X-Red-Hat-Base;X-Red-Hat-Base-Only;/Science;Math;/' wxmaxima.desktop

#   # Install desktop file and icon
#   install -m755 -d "${pkgdir}/usr/share/applications"
#   install -m755 -d "${pkgdir}/usr/share/pixmaps"
#   install -m644 wxmaxima.desktop "${pkgdir}/usr/share/applications/" || return 1
#   install -m644 data/wxmaxima.png "${pkgdir}/usr/share/pixmaps/" || return 1
# }
