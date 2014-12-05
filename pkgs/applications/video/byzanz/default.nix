{ stdenv, fetchgit, which, gnome3_12, glib, intltool, pkgconfig, libtool, cairo, gtk3, gst_all_1 }:

stdenv.mkDerivation rec {
  version = "0.2.3.alpha";
  name = "byzanz-${version}";

  src = fetchgit {
    url = git://github.com/GNOME/byzanz;
    rev = "1875a7f6a3903b83f6b1d666965800f47db9286a";
    sha256 = "1b7hyilwj9wf2ri5zq63889bvskagdnqjc91hvyjmx1aj7vdkzd4";
  };

  patches = [ ./add-amflags.patch ];

  preBuild = ''
    ./autogen.sh --prefix=$out
  '';

  buildInputs = [ which gnome3_12.gnome_common glib intltool pkgconfig libtool cairo gtk3 gst_all_1.gstreamer gst_all_1.gst-plugins-base ];

  meta = with stdenv.lib; {
    description = "Tool to record a running X desktop to an animation suitable for presentation in a web browser";
    homepage = https://github.com/GNOME/byzanz;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.DamienCassou ];
  };
}
