{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "arrpc";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "OpenAsar";
    repo = "arrpc";
    tag = version;
    hash = "sha256-3xkqWcLhmSIH6Al2SvM9qBpdcLzEqUmUCgwYBPAgVpo=";
  };

  npmDepsHash = "sha256-lw6pngFC2Pnk+I8818TOTwN4r+8IsjvdMYIyTsTi49g=";

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
