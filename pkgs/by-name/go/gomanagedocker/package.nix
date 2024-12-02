{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  darwin,
  xorg,
}:
let
  version = "1.4";
in
buildGoModule {
  pname = "gomanagedocker";
  inherit version;

  src = fetchFromGitHub {
    owner = "ajayd-san";
    repo = "gomanagedocker";
    rev = "refs/tags/v${version}";
    hash = "sha256-oM0DCOHdVPJFWgmHF8yeGGo6XvuTCXar7NebM1obahg=";
  };

  vendorHash = "sha256-M/jfQWCBrv7hZm450yLBmcjWtNSCziKOpfipxI6U9ak=";

  buildInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ xorg.libX11 ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "TUI tool to manage your docker images, containers and volumes";
    homepage = "https://github.com/ajayd-san/gomanagedocker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "gomanagedocker";
  };
}
