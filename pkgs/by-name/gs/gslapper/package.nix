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
  version = "1.5.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Nomadcxx";
    repo = "gSlapper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Otjo4a/Yz2ozT0jeJtW7du69dnw/cuYHzHiwNcxyD9Y=";
  };

  strictDeps = true;
  doCheck = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    libglvnd
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

  postPatch = ''
    substituteInPlace src/process_utils.c \
      --replace-fail 'posix_spawnp(&child, "pidof"' \
                     'posix_spawnp(&child, "${lib.getExe' procps "pidof"}"'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GStreamer-based Wayland wallpaper daemon for images and video";
    homepage = "https://github.com/Nomadcxx/gSlapper";
    changelog = "https://github.com/Nomadcxx/gSlapper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nikolaizombie1
      nomadcxx
    ];
    mainProgram = "gslapper";
    platforms = lib.platforms.linux;
  };
})
