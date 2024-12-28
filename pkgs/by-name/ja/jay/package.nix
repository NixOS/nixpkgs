{ lib
, rustPlatform
, fetchFromGitHub
, libGL
, libinput
, libxkbcommon
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
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "mahkoh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VAg59hmI38hJzkh/Vtv6LjrqQFLaq7rIGtk9sfQe1TA=";
  };

  cargoHash = "sha256-qYyuVNYhsHjR4uGdQq83Ih5TMBdlKmG0l4MxDa9wgD8=";

  SHADERC_LIB_DIR = "${lib.getLib shaderc}/lib";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    libGL
    libxkbcommon
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
