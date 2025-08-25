{
  lib,
  fetchFromGitHub,
}:

fetchFromGitHub rec {
  pname = "badger";
  version = "1.2.0";

  owner = "fosrl";
  repo = "badger";
  tag = "v${version}";
  hash = "sha256-iHL2amAuiiufb9hlokRP14wHq2Ei2eQdUlYP4FmpS9o=";

  meta = {
    description = "Traefik plugin that handles authentication for Pangolin resources";
    homepage = "https://github.com/fosrl/badger";
    changelog = "https://github.com/fosrl/badger/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jackr
      sigmasquadron
    ];
    platforms = lib.platforms.linux;
  };
}
