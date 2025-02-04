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
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "mahkoh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RGBFIYVeunMhZbpRExKYh7VlhodOsCN7WzN/7UPEJdc=";
  };

  cargoHash = "sha256-/+BdhSoRgDGibcHb+zqmtGzRHFXEgfavpBD0FQ03kyI=";

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
