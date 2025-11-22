{
  lib,
  buildNpmPackage,
  pnpm_9,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildNpmPackage rec {
  pname = "piped";
  version = "0-unstable-2025-11-17";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "piped";
    rev = "f1ccc788017873284ca6348161efae78ba0ad4ca";
    hash = "sha256-Y4raGhtoKogybTQjoKGQjy8nHBAT4dinfUg0WuusEMk=";
  };

  npmConfigHook = pnpm_9.configHook;

  installPhase = ''
    runHook preInstall
    cp dist $out -r
    runHook postInstall
  '';

  npmDeps = pnpmDeps;
  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    fetcherVersion = 2;
    hash = "sha256-/450kGvGOF+2c1cmtr6/cnzqMEqla2tghVGt5MKJNcg=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/TeamPiped/Piped";
    description = "Efficient and privacy-friendly YouTube frontend";
    maintainers = [ lib.maintainers.lucasew ];
    license = [ lib.licenses.agpl3Plus ];
  };

}
