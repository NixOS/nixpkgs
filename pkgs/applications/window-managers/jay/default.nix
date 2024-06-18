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
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "mahkoh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-D+dG0/MSC6LzGZBMNofU8WKVYvn52kNWunXExQPoOu8=";
  };

  cargoHash = "sha256-WEEAFr5lemyOfeIKC9Pvr9sYMz8rLO6k1BFgbxXJ0Pk=";

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
    platforms   = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "jay";
  };
}
