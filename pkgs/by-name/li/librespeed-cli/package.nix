{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "librespeed-cli";
  version = "1.0.15";

  src = fetchFromGitHub {
    owner = "librespeed";
    repo = "speedtest-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M+N3CAFSamWrkZEn8OO0nyg90R6LhG1t5cITpG9aiz4=";
  };

  vendorHash = "sha256-uZnp8oItVqPv3Uw2gO/DVl1nCra+trnkqMk/3pdwFQw=";

  # Tests have additional requirements
  doCheck = false;

  postInstall = ''
    mv $out/bin/speedtest-cli $out/bin/librespeed-cli
  '';

  meta = {
    description = "Command line client for LibreSpeed";
    homepage = "https://github.com/librespeed/speedtest-cli";
    changelog = "https://github.com/librespeed/speedtest-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "librespeed-cli";
  };
})
