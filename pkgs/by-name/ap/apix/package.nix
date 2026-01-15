{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "apix";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "rhydianjenkins";
    repo = "apix";
    rev = "v${version}";
    sha256 = "sha256-UrXrear0HenwulQnuwu3aOYidMePPMwxCBjt1h7cbZY=";
  };

  vendorHash = "sha256-QFHmy/lYqPzhLxV3Cvi7p4AHtj+aiO0zggHCBNa3A28=";

  meta = {
    description = "A cli http client for managing/consuming multiple API domains";
    mainProgram = "apix";
    homepage = "https://github.com/rhydianjenkins/apix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      rhydianjenkins
    ];
  };
}
