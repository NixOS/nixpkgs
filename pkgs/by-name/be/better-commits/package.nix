{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "better-commits";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "Everduin94";
    repo = "better-commits";
    tag = "v${version}";
    hash = "sha256-JgAe55aMr6gP9/dEj3rDW5glA+ntftthJSCFYvtmWso=";
  };

  npmDepsHash = "sha256-7+WMrkAYKQgUdOBI4jSOTt6gxwfCwft4GcUKMvpTiYc=";

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
