{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "irmago";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "privacybydesign";
    repo = "irmago";
    tag = "v${version}";
    hash = "sha256-KhTaxMCoc9e6aJcGZ0bz4438ln4qky8Xr07UVmHiv7s=";
  };

  vendorHash = "sha256-JUwzhngYf50PhknAladHrO/67z9UmLpr5f9LeLX5fI4=";

  subPackages = [ "irma" ];

  meta = {
    changelog = "https://github.com/privacybydesign/irmago/releases/tag/${src.tag}";
    description = "IRMA CLI and server implementation in Go for privacy-preserving attribute issuance and verification";
    homepage = "https://docs.yivi.app/irma-cli";
    license = lib.licenses.asl20;
    mainProgram = "irmago";
    maintainers = with lib.maintainers; [
      jorritvanderheide
    ];
  };
}
