{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "helm-dashboard";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "komodorio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hjIo2AEXNcFK0z4op59NnC2R8GspF5t808DZ72AxgMw=";
  };

  vendorHash = "sha256-ROffm1SGYnhUcp46nzQ951eaeQdO1pb+f8AInm0eSq0=";

  # tests require internet access
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  meta = {
    description = "A simplified way of working with Helm";
    mainProgram = "helm-dashboard";
    longDescription = ''
      Helm Dashboard is an open-source project which offers a UI-driven way to view the installed Helm charts,
      see their revision history and corresponding k8s resources.
    '';
    homepage = "https://github.com/komodorio/helm-dashboard/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ qjoly ];
  };
}
