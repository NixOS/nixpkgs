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
, darwin
, libsoup_3
}:

stdenv.mkDerivation rec {
  pname = "glide-media-player";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "philn";
    repo = "glide";
    rev = version;
    hash = "sha256-dIXuWaoTeyVBhzr6VWxYBsn+CnUYG/KzhzNJtLLdRuI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-azvxW40fuKuF/N0qwzofFk1bZiNxyTN6YBFU5qHQkCA=";
  };

  postPatch = ''
    substituteInPlace scripts/meson_post_install.py \
      --replace "gtk-update-icon-cache" "gtk4-update-icon-cache"
    patchShebangs --build scripts/meson_post_install.py
  '' + lib.optionalString stdenv.isDarwin ''
    sed -i "/wayland,x11egl,x11glx/d" meson.build
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
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.IOKit
  ];

  # FIXME: gst-plugins-good missing libsoup breaks streaming
  # (https://github.com/nixos/nixpkgs/issues/271960)
  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libsoup_3 ]}")
  '';

  meta = with lib; {
    description = "Linux/macOS media player based on GStreamer and GTK";
    homepage = "https://philn.github.io/glide";
    license = licenses.mit;
    maintainers = with maintainers; [ aleksana ];
    mainProgram = "glide";
    platforms = platforms.unix;
    # error: could not find system library 'gstreamer-gl-1.0' required by the 'gstreamer-gl-sys' crate
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
