{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
}:

buildGoModule rec {
  pname = "cloud-nuke";
  version = "0.38.1";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-i+mhxcY7201YADNb+OHLoh4zLIBLwkWVBZ6RnYPOJaM=";
  };

  vendorHash = "sha256-OrTRHje3ks3eGsJNusWJTpL740OWj5jy1es52DfNDbI=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.VERSION=${version}"
  ];

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/cloud-nuke --set-default DISABLE_TELEMETRY true
  '';

  meta = with lib; {
    homepage = "https://github.com/gruntwork-io/cloud-nuke";
    description = "Tool for cleaning up your cloud accounts by nuking (deleting) all resources within it";
    mainProgram = "cloud-nuke";
    changelog = "https://github.com/gruntwork-io/cloud-nuke/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
