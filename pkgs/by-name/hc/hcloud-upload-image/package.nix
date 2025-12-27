{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

let
  version = "0.3.1";
in

buildGoModule {
  pname = "hcloud-upload-image";
  inherit version;

  src = fetchFromGitHub {
    owner = "apricote";
    repo = "hcloud-upload-image";
    tag = "v${version}";
    hash = "sha256-uAnEKSQUwlECvIjeUY8meYvTnMTDGxu2mxeRaSi5Abk=";
  };

  proxyVendor = true;
  vendorHash = "sha256-BDTs1aTU/nxD+zLnGYUYR/Ueo7PmH48zkzmkoZvJXyM=";
  subPackages = [ "." ];

  meta = {
    description = "Quickly upload any raw disk images into your Hetzner Cloud projects";
    homepage = "https://github.com/apricote/hcloud-upload-image";
    changelog = "https://github.com/apricote/hcloud-upload-image/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stephank ];
    mainProgram = "hcloud-upload-image";
  };
}
