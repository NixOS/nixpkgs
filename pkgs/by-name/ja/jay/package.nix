{ lib
, rustPlatform
, fetchFromGitHub
, libGL
, libinput
, pkgconf
, xkeyboard_config
, libgbm
, pango
, udev
, shaderc
, libglvnd
, vulkan-loader
, autoPatchelfHook
}:

rustPlatform.buildRustPackage rec {
  pname = "jay";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "mahkoh";
    repo = "jay";
    rev = "v${version}";
    sha256 = "sha256-dUp3QYno2rB3wuJmSvBpCqowSpfMQIJqUYc0lDVqVPA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ovQxpUrRZAP1lHlsObfbIsgIjgMp+BLf6Ul+mzDVN5o=";

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

  meta = with lib; {
    description = "Wayland compositor written in Rust";
    homepage = "https://github.com/mahkoh/jay";
    license = licenses.gpl3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "jay";
  };
}
