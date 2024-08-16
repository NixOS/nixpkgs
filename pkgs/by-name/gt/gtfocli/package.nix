{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gtfocli";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "cmd-tools";
    repo = "gtfocli";
    rev = "refs/tags/${version}";
    hash = "sha256-fSk/OyeUffYZOkHXM1m/a9traDxdllYBieMEfsv910Q=";
  };

  vendorHash = "sha256-yhN2Ve4mBw1HoC3zXYz+M8+2CimLGduG9lGTXi+rPNw=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "GTFO Command Line Interface for search binaries commands to bypass local security restrictions";
    homepage = "https://github.com/cmd-tools/gtfocli";
    changelog = "https://github.com/cmd-tools/gtfocli/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "gtfocli";
  };
}
