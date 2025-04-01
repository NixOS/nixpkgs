{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libGL,
  libinput,
  libxkbcommon,
  mesa,
  pango,
  udev,
  shaderc,
  libglvnd,
  vulkan-loader,
  autoPatchelfHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "jay";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "mahkoh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cuXFkG2YwS0w4xzr7jpjr0QmVA5UJfk5SpjIQKxN/LY=";
  };

  cargoHash = "sha256-w3ARwQlehJq9uNSQmbUjiWik4a2W3Ax/6/BIsdDUfKM=";

  SHADERC_LIB_DIR = "${lib.getLib shaderc}/lib";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    libGL
    libxkbcommon
    mesa
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
    install -D etc/jay.portal $out/usr/share/xdg-desktop-portal/portals/jay.portal
    install -D etc/jay-portals.conf $out/usr/share/xdg-desktop-portal/jay-portals.conf
  '';

  meta = with lib; {
    description = "Wayland compositor written in Rust";
    homepage = "https://github.com/mahkoh/jay";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "jay";
  };
}
