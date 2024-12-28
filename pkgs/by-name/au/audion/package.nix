{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "audion";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "audiusGmbH";
    repo = "audion";
    rev = "refs/tags/${version}";
    hash = "sha256-NtAzh7n5bJXMt73L+FJU3vuNoNgga3wYXdZ2TY8AjIA=";
  };

  cargoHash = "sha256-0jPAidJu3f3exXkVCLowR1zHsZ3bctWu+O2mQmSwSpE=";

  meta = with lib; {
    description = "Ping the host continuously and write results to a file";
    homepage = "https://github.com/audiusGmbH/audion";
    changelog = "https://github.com/audiusGmbH/audion/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "audion";
  };
}
