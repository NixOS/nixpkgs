{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, wrapGAppsHook
, glib
, gsound
, libgudev
, json-glib
, vala
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "feedbackd-unstable";
  version = "2021-01-25";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "feedbackd";
    rev = "v0.0.0+git${builtins.replaceStrings ["-"] [""] version}";
    sha256 = "184ag10sfzrka533inv6f38x6z769kq5jj56vdkcm65j5h786w5v";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
    vala
    gobject-introspection
  ];

  buildInputs = [
    glib
    gsound
    libgudev
    json-glib
  ];

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    sed "s|/usr/libexec/|$out/libexec/|" < $src/debian/feedbackd.udev > $out/lib/udev/rules.d/90-feedbackd.rules
  '';

  meta = with lib; {
    description = "A daemon to provide haptic (and later more) feedback on events";
    homepage = "https://source.puri.sm/Librem5/feedbackd";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pacman99 ];
    platforms = platforms.linux;
  };
}

