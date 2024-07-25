{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkgconfig
, gcr
, glib
, gnome-desktop
, gtk3
, libgudev
, libjson
, json-glib
, libhandy
, networkmanager
, linux-pam
, systemd
, upower
, wayland
, libxkbcommon
, python3
, phoc
}:

stdenv.mkDerivation rec {
  pname = "phog";
  version = "0.1.3";

  src = fetchFromGitLab {
    owner = "mobian1";
    repo = "phog";
    rev = version;
    hash = "sha256-zny1FUYKwVXVSBGTh8AFVtMBS7dWZHTKO2gkPNPSL2M=";
  };

  # post_install is not passed two arguments, only one, so this doesn't work.
  # This is probably a leftover from phosh/phog fork.
  postPatch = ''
    patchShebangs build-aux/post_install.py
  '';

  # DESTDIR needs to be set, but empty, in order to allow the post_install.py
  # script to execute and not cause meson to crash
  DESTDIR = "";

  mesonFlags = [ "-Dcompositor=${phoc}/bin/phoc" ];

  buildInputs = [
    gcr
    glib
    gnome-desktop
    gtk3
    libgudev
    libjson
    json-glib
    libhandy
    networkmanager
    linux-pam
    systemd
    upower
    wayland
    libxkbcommon
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    python3
  ];

  meta = with lib; {
    description = "Greetd-compatible greeter for mobile phones";
    homepage = "https://gitlab.com/mobian1/phog/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
