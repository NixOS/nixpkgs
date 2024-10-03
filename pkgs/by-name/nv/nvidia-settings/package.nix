{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gnum4,
  gtk2,
  gtk3,
  jansson,
  libvdpau,
  vulkan-headers,
  wayland-scanner,
  xorg,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "nvidia-settings";
  version = "565.77";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-settings";
    tag = version;
    hash = "sha256-VUetj3LlOSz/LB+DDfMCN34uA4bNTTpjDrb6C6Iwukk=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gnum4
    gtk2
    gtk3
    jansson
    libvdpau.dev
    vulkan-headers
    wayland-scanner
    xorg.libXv.dev
    xorg.libXxf86vm.dev
  ];

  enableParallelBuilding = true;

  env.NV_USE_BUNDLED_LIBJANSSON = "0";

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    install -D -m644 doc/nvidia-settings.desktop "$out/share/applications/nvidia-settings.desktop"
    install -D -m644 doc/nvidia-settings.png "$out/share/pixmaps/nvidia-settings.png"
    sed \
      -e "s:__UTILS_PATH__:$out/bin:" \
      -e "s:__PIXMAP_PATH__:$out/share/pixmaps:" \
      -e 's/__NVIDIA_SETTINGS_DESKTOP_CATEGORIES__/Settings;HardwareSettings;/' \
      -e 's/Icon=.*/Icon=nvidia-settings/' \
      -i "$out/share/applications/nvidia-settings.desktop"
  '';

  postFixup = ''
    patchelf $out/bin/nvidia-settings --add-rpath $out/lib
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Tool for configuring the NVIDIA graphics driver";
    homepage = "https://github.com/NVIDIA/nvidia-settings";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ners ];
  };
}
