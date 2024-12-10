{
  lib,
  buildGoModule,
  fetchFromGitHub,
  enableGUI ? false, # upstream working in progress
  pkg-config,
  glfw,
  xorg,
  libXcursor,
  libXrandr,
  libXinerama,
  xinput,
  libXi,
  libXxf86vm,
}:
buildGoModule rec {
  pname = "bepass";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "bepass-org";
    repo = "bepass";
    rev = "v${version}";
    hash = "sha256-ruOhPWNs1WWM3r6X+6ch0HoDCu/a+IkBQiCr0Wh6yS8=";
  };

  vendorHash = "sha256-Juie/Hq3i6rvAK19x6ah3SCQJL0uCrmV9gvzHih3crY=";

  subPackages = [
    "cmd/cli"
  ];
  proxyVendor = true;
  nativeBuildInputs = lib.optionals enableGUI [ pkg-config ];
  buildInputs = lib.optionals enableGUI [
    glfw
    xorg.libXft
    libXcursor
    libXrandr
    libXinerama
    libXi
    xinput
    libXxf86vm
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/bepass
  '';

  meta = with lib; {
    homepage = "https://github.com/bepass-org/bepass";
    description = "A simple DPI bypass tool written in go";
    license = licenses.mit;
    mainProgram = "bepass";
    maintainers = with maintainers; [ oluceps ];
    broken = enableGUI;
  };
}
