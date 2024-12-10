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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "mahkoh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cfX9KcXbBRIaYrR7c+aIQrg+mvLJIM1sEzJ0J7wshMU=";
  };

  cargoHash = "sha256-htAXhjCBOb8qTAAKdFqTaTSefJJTFlvEBYveOokyWjs=";

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
    description = "A Wayland compositor written in Rust";
    homepage = "https://github.com/mahkoh/jay";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "jay";
  };
}
