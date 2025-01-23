{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "docker-compose-language-service";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "compose-language-service";
    rev = "v${version}";
    hash = "sha256-UBnABi7DMKrAFkRA8H6us/Oq4yM0mJ+kwOm0Rt8XnGw=";
  };

  npmDepsHash = "sha256-G1X9WrnwN6wM9S76PsGrPTmmiMBUKu4T2Al3HH3Wo+w=";

  meta = with lib; {
    description = "Language service for Docker Compose documents";
    homepage = "https://github.com/microsoft/compose-language-service";
    changelog = "https://github.com/microsoft/compose-language-service/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "docker-compose-langserver";
  };
}
