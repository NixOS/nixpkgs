{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "librespeed-cli";
  version = "1.0.12";

  src = fetchFromGitHub {
    owner = "librespeed";
    repo = "speedtest-cli";
    tag = "v${version}";
    hash = "sha256-njaQ/Be5rDCqkZJkij0nRi8aIO5uZYo8t3BjIcdKoCM=";
  };

  vendorHash = "sha256-dmaq9+0FjqYh2ZLg8bu8cPJZ9QClcvwid1nmsftmrf0=";

  # Tests have additional requirements
  doCheck = false;

  postInstall = ''
    mv $out/bin/speedtest-cli $out/bin/librespeed-cli
  '';

  meta = with lib; {
    description = "Command line client for LibreSpeed";
    homepage = "https://github.com/librespeed/speedtest-cli";
    changelog = "https://github.com/librespeed/speedtest-cli/releases/tag/${src.tag}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "librespeed-cli";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
