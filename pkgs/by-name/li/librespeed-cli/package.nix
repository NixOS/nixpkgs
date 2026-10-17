{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "librespeed-cli";
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "librespeed";
    repo = "speedtest-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5UFF2DCFHjt+PR2neir8tR+cRe5Clx1UkB0w+dW7IKs=";
  };

  vendorHash = "sha256-c7t6cYWB4eifhAKH5cNbzB5eA9pcdzBiJyHmNp3MCr4=";

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
