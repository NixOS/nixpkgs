{ stdenv
, fetchFromGitHub
, fetchFromGitLab
, git
, meson
, ninja
, pkgconfig
, wrapGAppsHook
, alsaLib
, glm
, gobject-introspection
, gtk-layer-shell
, gtkmm3
, libjpeg
, libnotify
, libpulseaudio
, wayfire
, wayland
, wayland-protocols
, wf-config
}:

stdenv.mkDerivation rec {
  pname = "wf-shell";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "0kfr1gw0pkd3jvb9qh2hhc9xb0n407jn4l4fzzvj6rqrrzfg3a58";
  };

  nativeBuildInputs = [
    git
    meson
    ninja
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    alsaLib
    glm
    gobject-introspection
    gtk-layer-shell
    gtkmm3
    libjpeg
    libnotify
    libpulseaudio
    wayfire
    wayland
    wayland-protocols
    wf-config
  ];

  prePatch = ''
    sed "s|wayfire.get_variable(pkgconfig: 'metadatadir')|'$out/share/wayfire/metadata'|g" -i meson.build
  '';

  meta = with stdenv.lib; {
    description = "A GTK3-based panel for wayfire";
    homepage = "https://wayfire.org/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Thra11 wucke13 ];
  };
}
