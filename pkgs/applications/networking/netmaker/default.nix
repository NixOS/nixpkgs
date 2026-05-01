{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libglvnd,
  pkg-config,
  subPackages ? [
    "."
    "netclient"
  ],
  libxrandr,
  libxi,
  libxinerama,
  libxcursor,
  libx11,
}:

buildGoModule rec {
  pname = "netmaker";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netmaker";
    rev = "v${version}";
    hash = "sha256-eN6H63bobU8pKCcqDWFa6RtXSh4Il304tcNj/ga171Y=";
  };

  vendorHash = "sha256-w5SjvXKp0G0fR886nxJhDl98R+4HJkVglyqZDRPRcjI=";

  inherit subPackages;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libglvnd
    libx11
    libxcursor
    libxi
    libxinerama
    libxrandr
  ];

  meta = {
    description = "WireGuard automation from homelab to enterprise";
    homepage = "https://netmaker.io";
    changelog = "https://github.com/gravitl/netmaker/-/releases/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      qjoly
    ];
    mainProgram = "netmaker";
  };
}
