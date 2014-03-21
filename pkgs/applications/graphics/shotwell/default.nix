{ fetchurl, stdenv, m4, glibc, gtk3, libexif, libgphoto2, libsoup, libxml2, vala, sqlite, webkit
, pkgconfig, gnome3, gst_all_1, which, udev, libraw, glib, json_glib, gettext, desktop_file_utils
, lcms2, gdk_pixbuf, librsvg, makeWrapper }:

# for dependencies see http://www.yorba.org/projects/shotwell/install/

let
  rest = stdenv.mkDerivation rec {
    name = "rest-0.7.12";

    src = fetchurl {
      url = "mirror://gnome/sources/rest/0.7/${name}.tar.xz";
      sha256 = "0fmg7fq5fx0jg3ryk71kwdkspsvj42acxy9imk7vznkqj29a9zqn";
    };
    
    configureFlags = "--with-ca-certificates=/etc/ssl/certs/ca-bundle.crt";
    
    buildInputs = [ pkgconfig glib libsoup ];
  };
in stdenv.mkDerivation rec {
  version = "0.15.1";
  name = "shotwell-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/shotwell/0.15/${name}.tar.xz";
    sha256 = "12qbqba226q9wb0m31xx8w0m968sr1n18qa4mbz75wblhwws0j7b";
  };

  NIX_CFLAGS_COMPILE = "-I${glib}/include/glib-2.0 -I${glib}/lib/glib-2.0/include";
  
  configureFlags = [ "--disable-gsettings-convert-install" ];
  
  preConfigure = ''
    patchShebangs .
  '';
  
  postInstall = ''
    wrapProgram "$out/bin/shotwell" \
     --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
     --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gtk3}/share:$out/share"
  '';


  buildInputs = [ m4 glibc gtk3 libexif libgphoto2 libsoup libxml2 vala sqlite webkit pkgconfig
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base gnome3.libgee which udev gnome3.gexiv2
                  libraw rest json_glib gettext desktop_file_utils glib lcms2 gdk_pixbuf librsvg
                  makeWrapper ];

  meta = with stdenv.lib; {
    description = "Popular photo organizer for the GNOME desktop";
    homepage = http://www.yorba.org/projects/shotwell/;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [iElectric];
    platforms = platforms.linux;
  };
}
