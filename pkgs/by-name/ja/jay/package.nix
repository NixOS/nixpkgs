{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libGL,
  libinput,
  pkgconf,
  xkeyboard_config,
  libgbm,
  pango,
  udev,
  shaderc,
  libglvnd,
  vulkan-loader,
  autoPatchelfHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "jay";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "mahkoh";
    repo = "jay";
    rev = "v${version}";
    sha256 = "sha256-wrA/UGxhIUMc2T+0/UNKS9iN44pe9ap2l+xL8ZE5jsI=";
  };

  cargoHash = "sha256-2LfEktaHB+uIQSWeSFG+v7+7wfkGlDz54m7P4KttPLI=";

  SHADERC_LIB_DIR = "${lib.getLib shaderc}/lib";

  nativeBuildInputs = [
    autoPatchelfHook
    pkgconf
  ];

  buildInputs = [
    libGL
    xkeyboard_config
    libgbm
    pango
    udev
    libinput
    shaderc
  ];

  runtimeDependencies = [
    libglvnd
    vulkan-loader
  ];

  postInstall = ''
    install -D etc/jay.portal $out/share/xdg-desktop-portal/portals/jay.portal
    install -D etc/jay-portals.conf $out/share/xdg-desktop-portal/jay-portals.conf
  '';

  meta = {
    description = "Wayland compositor written in Rust";
    homepage = "https://github.com/mahkoh/jay";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "jay";
  };
}
