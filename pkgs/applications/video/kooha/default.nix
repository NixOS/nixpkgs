{ lib
, stdenv
, fetchFromGitHub
, appstream-glib
, desktop-file-utils
, glib
, gobject-introspection
, gst_all_1
, gtk4
, libadwaita
, libpulseaudio
, librsvg
, meson
, ninja
, pkg-config
, python3
, rustPlatform
, wayland
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "kooha";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "SeaDve";
    repo = "Kooha";
    rev = "v${version}";
    sha256 = "05ynpwjdpl7zp9f17zhhvb59rbz3gd7hc0amla1g85ldgfxbgl00";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256:16zf6vb001z7xdv2g4kpmb2vqsmaql2cpsx1rl9zrfhpl2z6frs9";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    python3
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
    wayland
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gobject-introspection
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gtk4
    libadwaita
    libpulseaudio
    librsvg
  ];

  propagatedBuildInputs = [ python3.pkgs.pygobject3 ];

  strictDeps = false;

  # Fixes https://github.com/NixOS/nixpkgs/issues/31168
  postPatch = ''
    patchShebangs build-aux/meson_post_install.py
    substituteInPlace meson.build --replace '>= 1.0.0-alpha.1' '>= 1.0.0'
  '';

  doCheck = true;

  # thread 'main' panicked at 'Unable to start GTK4.: BoolError { message: "Failed to
  # initialize GTK", filename: "/build/kooha-2.0.1-vendor.tar.gz/gtk4/src/rt.rs", function: "gtk4::rt", line: 120 }', src/main.rs:37:17
  doInstallCheck = false;

  installCheckPhase = ''
    $out/bin/kooha --help
  '';

  meta = with lib; {
    description = "Simple screen recorder";
    homepage = "https://github.com/SeaDve/Kooha";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ austinbutler ];
  };
}
