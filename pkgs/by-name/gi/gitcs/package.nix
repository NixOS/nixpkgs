{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gitcs";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "knbr13";
    repo = "gitcs";
    rev = "v${version}";
    hash = "sha256-IyhVVRTKftZIzqMH5pBUMLPIk8bk0rVAxPKD6bABP68=";
  };

  vendorHash = "sha256-8yzPdVljnODOeI5yWh19BHsF4Pa9BWc49IwenMCVGZo=";

  ldflags = [ "-s" ];

  meta = with lib; {
    description = "Scan local git repositories and generate a visual contributions graph";
    changelog = "https://github.com/knbr13/gitcs/releases/tag/v${version}";
    homepage = "https://github.com/knbr13/gitcs";
    license = licenses.mit;
    maintainers = with maintainers; [ phanirithvij ];
    mainProgram = "gitcs";
  };
}
