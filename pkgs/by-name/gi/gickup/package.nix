{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gickup";
  version = "0.10.31";

  src = fetchFromGitHub {
    owner = "cooperspencer";
    repo = "gickup";
    rev = "refs/tags/v${version}";
    hash = "sha256-6du9x5QQN1VJzAABJ+8Fm3YscfoRwKVYZO9tTMz22AQ=";
  };

  vendorHash = "sha256-Nmt7T6sDWVHQZuINvON24Mq638Q04r5bpOBnz2vp4vM=";

  ldflags = [ "-X main.version=${version}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to backup repositories";
    homepage = "https://github.com/cooperspencer/gickup";
    changelog = "https://github.com/cooperspencer/gickup/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "gickup";
    license = lib.licenses.asl20;
  };
}
