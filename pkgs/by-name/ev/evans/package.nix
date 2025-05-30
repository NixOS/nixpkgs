{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "evans";
  version = "0.10.11";

  src = fetchFromGitHub {
    owner = "ktr0731";
    repo = "evans";
    rev = "v${version}";
    sha256 = "sha256-V5M7vXlBSQFX2YZ+Vjt63hLziWy0yuAbCMmSZFEO0OA=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-oyFPycyQoYnN261kmGhkN9NMPMA6XChf4jXlYezKiCo=";

  meta = with lib; {
    description = "More expressive universal gRPC client";
    mainProgram = "evans";
    homepage = "https://evans.syfm.me/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ diogox ];
  };
}
