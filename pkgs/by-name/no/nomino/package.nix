{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nomino";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "yaa110";
    repo = "nomino";
    rev = version;
    hash = "sha256-By7zVHtbrQU0+cSbxNNxCcmTCoFABsjOLk8TCX8iFWA=";
  };

  cargoHash = "sha256-daHhCr55RzIHooGXBK831SYD1b8NPEDD6mtDut6nuaQ=";

  meta = with lib; {
    description = "Batch rename utility for developers";
    homepage = "https://github.com/yaa110/nomino";
    changelog = "https://github.com/yaa110/nomino/releases/tag/${src.rev}";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = [ ];
    mainProgram = "nomino";
  };
}
