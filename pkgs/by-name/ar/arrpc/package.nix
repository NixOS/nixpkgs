{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "arrpc";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "OpenAsar";
    repo = "arrpc";
    tag = version;
    hash = "sha256-WSwnCE3hs3Rj42XDbPtxuYL8tAlfzuWPkIypKzCu8EQ=";
  };

  npmDepsHash = "sha256-A98oNT1rGctSlJG9yLaa6i0VsGMIo1r2NoNk00SVupk=";

  dontNpmBuild = true;

  postInstall = ''
    mkdir -p $out/lib/systemd/user
    substitute ${./arrpc.service} $out/lib/systemd/user/arrpc.service \
      --subst-var-by arrpc $out/bin/arrpc
  '';

  meta = {
    changelog = "https://github.com/OpenAsar/arrpc/blob/${version}/changelog.md";
    description = "Open Discord RPC server for atypical setups";
    homepage = "https://arrpc.openasar.dev/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      anomalocaris
      NotAShelf
      ulysseszhan
    ];
    mainProgram = "arrpc";
  };
}
