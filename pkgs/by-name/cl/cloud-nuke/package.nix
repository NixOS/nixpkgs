{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "cloud-nuke";
  version = "0.51.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "cloud-nuke";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tJi3SFBp/zuBB+0S0IOIWqvZRWdlSyJra8K4meJHXnY=";
  };

  vendorHash = "sha256-1DMwVJvr3zU96yAV2Vb4v58VNt7xg9dLCH7XGEMopjQ=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.VERSION=${finalAttrs.version}"
  ];

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/cloud-nuke --set-default DISABLE_TELEMETRY true
  '';

  meta = {
    homepage = "https://github.com/gruntwork-io/cloud-nuke";
    description = "Tool for cleaning up your cloud accounts by nuking (deleting) all resources within it";
    mainProgram = "cloud-nuke";
    changelog = "https://github.com/gruntwork-io/cloud-nuke/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
