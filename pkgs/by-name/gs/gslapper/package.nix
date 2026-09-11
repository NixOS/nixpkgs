{
  meson,
  pkg-config,
  wayland-protocols,
  wayland,
  egl-wayland,
  libglvnd,
  gst_all_1,
  systemd,
  wayland-scanner,
  ninja,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  lib,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gslapper";
  version = "v1.4.0";

  src = fetchFromGitHub {
    owner = "Nomadcxx";
    repo = "gSlapper";
    tag = finalAttrs.version;
    hash = "sha256-+FcKKp73Ooq+IB6wpLOoVSkS52AmNox9KbKtexH9PIo=";
  };

  nativeBuildInputs = [
    wayland-protocols
    egl-wayland
    libglvnd
    systemd
    wayland-scanner
    wayland
    wrapGAppsHook4
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  buildInputs = [
    meson
    pkg-config
    wayland-protocols
    wayland
    egl-wayland
    libglvnd
    systemd
    wayland-scanner
    ninja
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A wallpaper utility that handles static images and a huge number of video types via gstreamer.";
    longDescription = ''
      gSlapper is a wallpaper utility for Wayland that combines the best of
      swww and mpvpaper by allowing both static and video wallpapers. It uses
      GStreamer instead of libmpv making it more efficient and NVIDIA
      friendly for Wayland.
    '';
    homepage = "https://github.com/Nomadcxx/gSlapper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nikolaizombie1
    ];
    mainProgram = "gslapper";
    platforms = [ "x86_64-linux" ];
  };
})
