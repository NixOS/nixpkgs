{ stdenv, fetchFromGitHub, fetchpatch, pkgconfig, boost, dbus_glib, gnome3,
 xorg, help2man, intltool, libsigcxx, gcc7, wrapGAppsHook}: 

with stdenv.lib;

let
  version = "0.6.0-9-gf7c1614";
in stdenv.mkDerivation {
  name = "easystroke-${version}";

  src = fetchFromGitHub {
    owner = "thjaeger";
    repo = "easystroke";
    rev = "f7c1614004e9c518bd4f6f4b3a2ddaf23911a5ef";
    sha256 = "0map8zbnq993gchgw97blf085cbslry2sa3z4ambdcwbl0r9rd6x";
  };

  nativeBuildInputs = [ pkgconfig gcc7 wrapGAppsHook help2man ];
  buildInputs = [ boost dbus_glib gnome3.gtkmm xorg.libXtst xorg.inputproto 
    xorg.xorgserver intltool libsigcxx gnome3.defaultIconTheme
  ]; 

  enableParallelBuild = true; 

  patches = [ 
    (fetchpatch {
      url = "https://github.com/thjaeger/easystroke/pull/8.patch";
      sha256 = "1z6hhh7qvzfvryjiwxg2ki4xx00b53f3vha5amqc6bhyajndxpk4";
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/add-toggle-option.patch?h=easystroke-git";
      sha256 = "02bfd3bfvg7awid4l46jslwsqab7kc01gkjg8vfpjvb2h4aak30i";
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/dont-ignore-xshape-when-saving.patch?h=easystroke-git";
      sha256 = "0br37pn1ii46qz08rkprhaxq0s480h3vybc1q2sgym32wq7fv375";
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/sigc.patch?h=easystroke-git";
      sha256 = "0ygl2rk3aghsxpnj1i0g1bqwxadhgijazjd9jra2v3l8nvnwn6qr";
    })
  ];

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = {
    homepage = https://github.com/thjaeger/easystroke/wiki;
    description = "X11 gesture recognition application";
    license = licenses.isc;
    maintainers = with maintainers; [ psyky ];
    platforms = platforms.linux;
  };
}
