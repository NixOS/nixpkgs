{ stdenv, fetchurl, fetchpatch, pkgconfig, gtk2, poppler }:

stdenv.mkDerivation rec {
  name = "epdfview-${version}";
  version = "0.1.8";

  src = fetchurl {
    url = "mirror://debian/pool/main/e/epdfview/epdfview_${version}.orig.tar.gz";
    sha256 = "0ibyb60a0b4n34bsjgvhdw8yf24463ky0hpmf6a2jjqsbm5g4v64";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 poppler ];

  hardeningDisable = [ "format" ];

  patches = [ (fetchpatch {
                name = "epdfview-0.1.8-glib2-headers.patch";
                url = "https://projects.archlinux.org/svntogit/community.git/plain/trunk/epdfview-0.1.8-glib2-headers.patch?h=packages/epdfview&id=40ba115c860bdec31d03a30fa594a7ec2864d634";
                sha256 = "17df6s1zij5ficj67xszq6kd88cy620az3ic55065ccnmsd73f8h";
              })
              (fetchpatch {
                name = "epdfview-0.1.8-modern-cups.patch";
                url = "https://projects.archlinux.org/svntogit/community.git/plain/trunk/epdfview-0.1.8-modern-cups.patch?h=packages/epdfview&id=40ba115c860bdec31d03a30fa594a7ec2864d634";
                sha256 = "07yvgvai2bvbr5fa1mv6lg7nqr0qyryjn1xyjlh8nidg9k9vv001";
              })
            ];

  meta = with stdenv.lib; {
    homepage = https://packages.debian.org/wheezy/epdfview;
    description = "A lightweight PDF document viewer using Poppler and GTK+";
    longDescription = ''
        ePDFView is a free lightweight PDF document viewer using Poppler and
        GTK+ libraries. The aim of ePDFView is to make a simple PDF document
        viewer, in the lines of Evince but without using the Gnome libraries.
    '';
    license = licenses.gpl2;
    maintainers = [ maintainers.astsmtl ];
    platforms = platforms.linux;
  };
}
