{ lib
, rustPlatform
, fetchFromGitHub
, libGL
, libinput
, libxkbcommon
, mesa
, pango
, udev
, shaderc
, libglvnd
, vulkan-loader
, autoPatchelfHook
}:

rustPlatform.buildRustPackage rec {
  pname = "jay";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "mahkoh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9fWwVUqeYADt33HGaJRRFmM20WM7qRWbNGpt3rk9xQM=";
  };

  cargoSha256 = "sha256-oPGY/rVx94BkWgKkwwyDjfASMyGGU32R5IZuNjOv+EM=";

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
    platforms   = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "jay";
  };
}
