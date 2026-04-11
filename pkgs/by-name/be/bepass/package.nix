{
  lib,
  buildGoModule,
  fetchFromGitHub,
  enableGUI ? false, # upstream working in progress
  pkg-config,
  glfw,
  libxft,
  libxcursor,
  libxrandr,
  libxinerama,
  xinput,
  libxi,
  libxxf86vm,
}:
buildGoModule (finalAttrs: {
  pname = "bepass";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "bepass-org";
    repo = "bepass";
    rev = "v${finalAttrs.version}";
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
    libxft
    libxcursor
    libxrandr
    libxinerama
    libxi
    xinput
    libxxf86vm
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/bepass
  '';

  meta = {
    homepage = "https://github.com/bepass-org/bepass";
    description = "Simple DPI bypass tool written in go";
    license = lib.licenses.mit;
    mainProgram = "bepass";
    maintainers = with lib.maintainers; [ oluceps ];
    broken = enableGUI;
  };
})
