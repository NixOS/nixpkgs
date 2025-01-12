{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "emmet-language-server";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "olrtg";
    repo = "emmet-language-server";
    rev = "v${version}";
    hash = "sha256-R20twrmfLz9FP87qkjgz1R/n+Nhzwn22l9t/2fyuVeM=";
  };

  npmDepsHash = "sha256-yv+5/wBif75AaAsbJrwLNtlui9SHws2mu3jYOR1Z55M=";

  # Upstream doesn't have a lockfile
  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  meta = {
    description = "Language server for emmet.io";
    homepage = "https://github.com/olrtg/emmet-language-server";
    changelog = "https://github.com/olrtg/emmet-language-server/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "emmet-language-server";
  };
}
