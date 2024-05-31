{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, meson
, ninja
, rustc
, cargo
, wrapGAppsHook4
, python3
, libadwaita
, graphene
, gst_all_1
, glib-networking
}:

stdenv.mkDerivation rec {
  pname = "glide-media-player";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "philn";
    repo = "glide";
    rev = version;
    hash = "sha256-rWWMMuA41uFWazIJBVLxzaCrR5X5tI4x+GXXYkfeqz8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-Kvdbo5tkhwsah9W7Y5zqpoA3bVHfmjGj7Cjsqxkljls=";
  };

  postPatch = ''
    substituteInPlace scripts/meson_post_install.py \
      --replace-warn "gtk-update-icon-cache" "gtk4-update-icon-cache"
    substituteInPlace data/net.baseart.Glide.desktop \
      --replace-warn "Icon=net.baseart.Glide.svg" "Icon=net.baseart.Glide"
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
