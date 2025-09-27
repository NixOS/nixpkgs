{
  lib,
  stdenv,
  makeWrapper,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  argparse,
  gtk3,
  opencv,
  spdlog,
  usbutils,
  yaml-cpp,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "linux-enable-ir-emitter";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "EmixamPP";
    repo = "linux-enable-ir-emitter";
    rev = finalAttrs.version;
    hash = "sha256-Pi+PnhuvYXJEScMBhWDlo22iOlWpNFW0Q0OVjRkGpww=";
  };

  patches = [
    # Allows configuring config/log directories and whether to create them
    ./dirs.patch
  ];

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    argparse
    gtk3
    spdlog
    usbutils
    yaml-cpp
    (opencv.override { enableGtk3 = true; })
  ];

  mesonFlags = lib.lists.flatten [
    (lib.attrsets.mapAttrsToList lib.strings.mesonOption {
      "config_dir" = "/var/lib";
      "log_dir" = "/var/log";
    })
    (lib.attrsets.mapAttrsToList lib.strings.mesonBool {
      "create_config_dir" = false;
      "create_log_dir" = false;
    })
  ];

  meta = {
    description = "Provides support for infrared cameras that are not directly enabled out-of-the box";
    homepage = "https://github.com/EmixamPP/linux-enable-ir-emitter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fufexan ];
    mainProgram = "linux-enable-ir-emitter";
    platforms = lib.platforms.linux;
  };
})
