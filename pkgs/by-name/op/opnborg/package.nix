{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "opnborg";
  version = "0.1.64";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "opnborg";
    rev = "v${version}";
    hash = "sha256-v1+hN77l3Y7IyxoZWJqN96odpzKGQ0fiXfLRFgqy+IQ=";
  };

  vendorHash = "sha256-J4CKwjOkjBb2v/H3x+TTatW7dL7gZYYV8yAvz2pvjTE=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    changelog = "https://github.com/paepckehh/opnborg/releases/tag/v${version}";
    homepage = "https://paepcke.de/opnborg";
    description = "Sefhosted OPNSense Appliance Backup & Configuration Management Portal";
    license = lib.licenses.bsd3;
    mainProgram = "opnborg";
    maintainers = with lib.maintainers; [ paepcke ];
  };
}
