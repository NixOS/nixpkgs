{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
}:

buildGoModule rec {
  pname = "cloud-nuke";
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "cloud-nuke";
    tag = "v${version}";
    hash = "sha256-TDZiX4Ik07Ysz3I7gdEF8SVJnt+EBPlH0RBIaE7+1KQ=";
  };

  vendorHash = "sha256-Qml8P9m8quUZAarsS7h3TGbcXBCJ2fRD3uyi8Do+lAw=";

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

  meta = {
    homepage = "https://github.com/gruntwork-io/cloud-nuke";
    description = "Tool for cleaning up your cloud accounts by nuking (deleting) all resources within it";
    mainProgram = "cloud-nuke";
    changelog = "https://github.com/gruntwork-io/cloud-nuke/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
