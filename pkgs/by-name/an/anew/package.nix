{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "anew";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "tomnomnom";
    repo = "anew";
    tag = "v${version}";
    hash = "sha256-NQSs99/2GPOtXkO7k+ar16G4Ecu4CPGMd/CTwEhcyto=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool for adding new lines to files, skipping duplicates";
    mainProgram = "anew";
    homepage = "https://github.com/tomnomnom/anew";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
