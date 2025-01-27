{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  libepoxy,
  glib,
  gtk3,
  libpulseaudio,
  libsamplerate,
  gobject-introspection,
  vala,
  gtk-doc,
}:

stdenv.mkDerivation rec {
  pname = "retro-gtk";
  version = "1.0.2";

  src = fetchurl {
    url = "mirror://gnome/sources/retro-gtk/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1lnb7dwcj3lrrvdzd85dxwrlid28xf4qdbrgfjyg1wn1z6sv063i";
  };

  patches = [
    # https://gitlab.gnome.org/GNOME/retro-gtk/-/merge_requests/150
    ./gio-unix.patch
    # fix build with meson 0.60 (https://gitlab.gnome.org/GNOME/retro-gtk/-/merge_requests/167)
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/retro-gtk/-/commit/8016c10e7216394bc66281f2d9be740140b6fad6.patch";
      sha256 = "sha256-HcQnqadK5sJM5mMqi4KERkJM3H+MUl8AJAorpFDsJ68=";
    })
  ];

  nativeBuildInputs = [
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    libepoxy
    glib
    gtk3
    libpulseaudio
    libsamplerate
  ];

  meta = with lib; {
    description = "GTK Libretro frontend framework";
    mainProgram = "retro-demo";
    longDescription = ''
      Libretro is a plugin format design to implement video game
      console emulators, video games and similar multimedia
      software. Such plugins are called Libretro cores.

      RetroGTK is a framework easing the use of Libretro cores in
      conjunction with GTK.

      It encourages the cores to be installed in a well defined
      centralized place — namely the libretro subdirectory of your lib
      directory — and it recommends them to come with Libretro core
      descriptors.
    '';
    homepage = "https://gitlab.gnome.org/GNOME/retro-gtk";
    changelog = "https://gitlab.gnome.org/GNOME/retro-gtk/-/blob/master/NEWS";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.DamienCassou ];
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/retro-gtk.x86_64-darwin
  };
}
