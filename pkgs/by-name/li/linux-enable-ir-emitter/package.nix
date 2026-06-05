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
  python3,
  spdlog,
  usbutils,
  yaml-cpp,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "linux-enable-ir-emitter";
  version = "6.1.2";

  src = fetchFromGitHub {
    owner = "EmixamPP";
    repo = "linux-enable-ir-emitter";
    tag = finalAttrs.version;
    hash = "sha256-wSmWebX4H3Hj8bbFoVMq3DY3i/nKkQaeu3mXX0o6IaY=";
  };

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
    python3.pkgs.opencv4Full
  ];

  mesonFlags = lib.lists.flatten [
    (lib.attrsets.mapAttrsToList lib.strings.mesonOption {
      config_dir = "/var/lib";
      localstatedir = "/var";
    })
    (lib.attrsets.mapAttrsToList lib.strings.mesonBool {
      create_config_dir = false;
      create_log_dir = false;
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
