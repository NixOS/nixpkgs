{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "capslock";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "google";
    repo = "capslock";
    rev = "v${version}";
    hash = "sha256-xeezGU9bI1MwonSGv+XimSfboMQr/1TPMTduDQ+MP1g=";
  };

  vendorHash = "sha256-Z4oj+af8jqqhgHQrTb+lkbIMMa/yOnvkMti/s+wiQsI=";

  subPackages = [ "cmd/capslock" ];

  CGO_ENABLED = "0";

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Capability analysis CLI for Go packages that informs users of which privileged operations a given package can access";
    homepage = "https://github.com/google/capslock";
    license = lib.licenses.bsd3;
    mainProgram = "capslock";
    maintainers = with lib.maintainers; [ katexochen ];
  };
}
