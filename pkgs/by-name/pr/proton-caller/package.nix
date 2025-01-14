{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "proton-caller";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "caverym";
    repo = pname;
    rev = version;
    sha256 = "sha256-srzahBMihkEP9/+7oRij5POHkCcH6QBh4kGz42Pz0nM=";
  };

  cargoHash = "sha256-LBXCcFqqscCGgtTzt/gr7Lz0ExT9kAWrXPuPuKzKt0E=";

  meta = with lib; {
    description = "Run Windows programs with Proton";
    changelog = "https://github.com/caverym/proton-caller/releases/tag/${version}";
    homepage = "https://github.com/caverym/proton-caller";
    license = licenses.mit;
    maintainers = with maintainers; [ kho-dialga ];
    mainProgram = "proton-call";
  };
}
