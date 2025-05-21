{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gickup";
  version = "0.10.38";

  src = fetchFromGitHub {
    owner = "cooperspencer";
    repo = "gickup";
    tag = "v${version}";
    hash = "sha256-vthr4nkwuhvGXxH2P0uHeuQpjQFNTpGFHF+eXG2jiqk=";
  };

  vendorHash = "sha256-RtuEpvux+8oJ829WEvz5OPfnYvFCdNo/9GCXhjXurRM=";

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
