{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
}:

buildGoModule rec {
  pname = "cloud-nuke";
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "cloud-nuke";
    tag = "v${version}";
    hash = "sha256-ALeUZs3LHhkWU1ecnzp/rpNhobCw4QLX2Pm6yN0dB40=";
  };

  vendorHash = "sha256-TczKygsgAqDzNBJ8MOwCcMShD2Y8/F2awaeqg/OMCxg=";

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
