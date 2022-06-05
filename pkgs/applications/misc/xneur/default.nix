{ lib, stdenv, fetchurl, fetchpatch, pkg-config, intltool, xorg, pcre, gst_all_1, glib
, xosd, libnotify, enchant, wrapGAppsHook, gdk-pixbuf }:

stdenv.mkDerivation {
   pname = "xneur";
   version = "0.20.0";

  src = fetchurl {
    url = "https://github.com/AndrewCrewKuznetsov/xneur-devel/raw/f66723feb272c68f7c22a8bf0dbcafa5e3a8a5ee/dists/0.20.0/xneur_0.20.0.orig.tar.gz";
    sha256 = "1lg3qpi9pkx9f5xvfc8yf39wwc98f769yb7i2438vqn66kla1xpr";
  };

  nativeBuildInputs = [
    pkg-config intltool wrapGAppsHook
  ];

  buildInputs = [
    xorg.libX11 xorg.libXtst pcre gst_all_1.gstreamer glib
    xosd xorg.libXext xorg.libXi libnotify
    enchant gdk-pixbuf
    gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
  ];

  patches = [
    (fetchpatch {
      name = "gcc-10.patch";
      url = "https://salsa.debian.org/debian/xneur/-/raw/da38ad9c8e1bf4e349f5ed4ad909f810fdea44c9/debian/patches/gcc-10.patch";
      sha256 = "0pc17a4sdrnrc4z7gz28889b9ywqsm5mzm6m41h67j2f5zh9k3fy";
    })
  ];

  postPatch = ''
    sed -e 's@for xosd_dir in@for xosd_dir in ${xosd} @' -i configure
  '';

  meta = with lib; {
    description = "Utility for switching between keyboard layouts";
    homepage = "https://xneur.ru";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
