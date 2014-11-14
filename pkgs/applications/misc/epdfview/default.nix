{ stdenv, fetchurl, fetchpatch, pkgconfig, gtk, poppler }:
stdenv.mkDerivation rec {
  name = "epdfview-0.1.8";
  src = fetchurl {
    url = "http://trac.emma-soft.com/epdfview/chrome/site/releases/${name}.tar.bz2";
    sha256 = "1w7qybh8ssl4dffi5qfajq8mndw7ipsd92vkim03nywxgjp4i1ll";
  };
  buildInputs = [ pkgconfig gtk poppler ];
  patches = [ (fetchpatch {
                name = "epdfview-0.1.8-glib2-headers.patch";
                url = "https://projects.archlinux.org/svntogit/community.git/plain/trunk/epdfview-0.1.8-glib2-headers.patch?h=packages/epdfview&id=40ba115c860bdec31d03a30fa594a7ec2864d634";
                sha256 = "13ha8l3ysw065wr1gpi33dr3r23pv2w51iczzkx6pnxsqk9cda4f";
              })
              (fetchpatch {
                name = "epdfview-0.1.8-modern-cups.patch";
                url = "https://projects.archlinux.org/svntogit/community.git/plain/trunk/epdfview-0.1.8-modern-cups.patch?h=packages/epdfview&id=40ba115c860bdec31d03a30fa594a7ec2864d634";
                sha256 = "15pjriq0ppnjgmr26r9zj9smv301w8szwps6n87sshm0yiw9sli7";
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
