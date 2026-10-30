{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  procps,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libglvnd,
  systemd,
  gst_all_1,
  wrapGAppsNoGuiHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gslapper";
  version = "1.5.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Nomadcxx";
    repo = "gSlapper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nSAxzLHh6fD755Kq965khZJYoo0rAgZ0ZIJohwmwEOY=";
  };

  strictDeps = true;
  doCheck = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    procps
    wayland-scanner
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    libglvnd
    procps
    systemd
    wayland
    wayland-protocols
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-libav
  ]);

  # ponytail: combine runtime paths with the GApps wrapper instead of nesting wrappers.
  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ procps ]})
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GStreamer-based Wayland wallpaper daemon for images and video";
    homepage = "https://github.com/Nomadcxx/gSlapper";
    changelog = "https://github.com/Nomadcxx/gSlapper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nikolaizombie1 ];
    mainProgram = "gslapper";
    platforms = lib.platforms.linux;
  };
})
