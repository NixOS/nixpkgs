{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
}:

buildGoModule rec {
  pname = "cook-framework";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "glitchedgitz";
    repo = "cook";
    tag = "v${version}";
    hash = "sha256-DK0kbvM11t64nGkrzThZgSruHTCHAPP374YPWmoM50g=";
  };

  sourceRoot = "${src.name}/v2";

  vendorHash = "sha256-VpNr06IiVKpMsJXzcKCuNfJ+T+zeA9dMBMp6jeCRgn8=";

  doCheck = false; # uses network to fetch data sources

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Wordlist generator, splitter, merger, finder, saver for security researchers, bug bounty and hackers";
    homepage = "https://github.com/glitchedgitz/cook";
    changelog = "https://github.com/glitchedgitz/cook/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "cook";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
