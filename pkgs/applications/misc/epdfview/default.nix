{ stdenv, fetchurl, fetchpatch, pkgconfig, gtk, poppler }:

stdenv.mkDerivation rec {
  name = "epdfview-0.1.8";

  src = fetchurl {
    url = "http://trac.emma-soft.com/epdfview/chrome/site/releases/${name}.tar.bz2";
    sha256 = "1w7qybh8ssl4dffi5qfajq8mndw7ipsd92vkim03nywxgjp4i1ll";
  };

  buildInputs = [ pkgconfig gtk poppler ];

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

  meta = {
    homepage = http://trac.emma-soft.com/epdfview/;
    description = "A lightweight PDF document viewer using Poppler and GTK+";
    longDescription = ''
        ePDFView is a free lightweight PDF document viewer using Poppler and
        GTK+ libraries. The aim of ePDFView is to make a simple PDF document
        viewer, in the lines of Evince but without using the Gnome libraries.
    '';
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
