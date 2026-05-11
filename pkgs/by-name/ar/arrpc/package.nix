{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "arrpc";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "OpenAsar";
    repo = "arrpc";
    tag = version;
    hash = "sha256-2SYlCOgeaPsYIQmGj4/fdme0S36COolXxER3rDjIe20=";
  };

  npmDepsHash = "sha256-GNXQLOTuu+7QWjx1Y+eaAon70jj7XC3p5a7z7qJOB+Q=";

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
