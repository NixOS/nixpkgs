{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  meson,
  ninja,
  rustc,
  cargo,
  wrapGAppsHook4,
  python3,
  libadwaita,
  graphene,
  gst_all_1,
  glib-networking,
}:

stdenv.mkDerivation rec {
  pname = "glide-media-player";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "philn";
    repo = "glide";
    rev = version;
    hash = "sha256-gmBXUj6LxC7VDH/ni8neYivysagqcbI/UCUq9Ly3D24=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-5cohhm8/QP+vYzVf8iz3hLtu0ej7lQiHpDAC9I52+ME=";
  };

  postPatch = ''
    substituteInPlace scripts/meson_post_install.py \
      --replace-warn "gtk-update-icon-cache" "gtk4-update-icon-cache"
    substituteInPlace data/net.base_art.Glide.desktop \
      --replace-warn "Icon=net.base_art.Glide.svg" "Icon=net.baseart.Glide"
    patchShebangs --build \
      scripts/meson_post_install.py \
      build-aux/cargo-build.py
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    rustPlatform.cargoSetupHook
    rustc
    cargo
    wrapGAppsHook4
    python3
  ];

  buildInputs = [
    libadwaita
    graphene
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-good
    glib-networking
  ];

  meta = with lib; {
    description = "Linux/macOS media player based on GStreamer and GTK";
    homepage = "https://philn.github.io/glide";
    license = licenses.mit;
    maintainers = with maintainers; [ aleksana ];
    mainProgram = "glide";
    # Required gdk4-{wayland,x11} and gstreamer-gl not available on darwin
    platforms = subtractLists platforms.darwin platforms.unix;
  };
}
