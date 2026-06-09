{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "better-commits";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "Everduin94";
    repo = "better-commits";
    tag = "v${version}";
    hash = "sha256-OzQ6/ShE5V49hOvTbG2v6J/orDCulgaAQnU6S9w/Ayw=";
  };

  npmDepsHash = "sha256-1ASVbn8MqWDiDKx+vYs2DNv9GuvHg4Acv8Kuj7JVBHE=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for creating better commits following the conventional commits specification";
    homepage = "https://github.com/Everduin94/better-commits";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ilarvne ];
    platforms = lib.platforms.unix;
    mainProgram = "better-commits";
  };
}
