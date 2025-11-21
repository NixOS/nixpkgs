{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jaeles";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "jaeles-project";
    repo = "jaeles";
    rev = "beta-v${version}";
    hash = "sha256-IGvIjO1nCilg2sPyScGTH5Zmv0rORlGwRv3NRxQk+aM=";
  };

  vendorHash = "sha256-/Ow2qdcFduZ2ZyUUfCqpZxSh9yy3+tI/2N9Wl1fKXVI=";

  # Tests want to download signatures
  doCheck = false;

  meta = {
    description = "Tool for automated Web application testing";
    mainProgram = "jaeles";
    homepage = "https://github.com/jaeles-project/jaeles";
    changelog = "https://github.com/jaeles-project/jaeles/releases/tag/beta-v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
