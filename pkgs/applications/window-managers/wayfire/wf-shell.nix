{ stdenv
, fetchFromGitHub
, fetchFromGitLab
, meson
, ninja
, pkgconfig
, wayland
, wayland-protocols
, wf-config
, gtkmm3
, gobject-introspection
, libpulseaudio
, alsaLib
, libjpeg
, gtk-layer-shell
}:

let
  # fetch submodule
  libgnome-volume-control = fetchFromGitLab {
    rev = "468022b708fc1a56154f3b0cc5af3b938fb3e9fb";
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libgnome-volume-control";
    sha256 = "01wrl875r52v7f12yrx3qdn2d2s3h2xz7jx1dswydypd9b6qss0d";
  };
in
stdenv.mkDerivation rec {
  pname = "wf-shell";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = pname;
    rev = version;
    sha256 = "0xgr5lgrhdab3qm24z0ws1b7xz1mhf6m1gxzgj5wpr4pc7iwc7lw";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    wayland
    wayland-protocols
    wf-config
    gtkmm3
    gobject-introspection
    libpulseaudio
    alsaLib
    libjpeg
    gtk-layer-shell
  ];

  postUnpack = ''
    cp -r ${libgnome-volume-control}/* source/subprojects/gvc/
  '';

  postInstall = ''
    cp ../wf-shell.ini.example $out/share/
  '';

  meta = with stdenv.lib; {
    description = "A GTK3-based panel for wayfire";
    homepage = https://wayfire.org/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Thra11 ];
  };
}
