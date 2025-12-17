{
  lib,
  buildNpmPackage,
  pnpm_9,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildNpmPackage rec {
  pname = "piped";
  version = "0-unstable-2025-12-13";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "piped";
    rev = "1c3cfd236ec91685466273430fd6966974320ff2";
    hash = "sha256-ONOXnMhcs7irE9JnDnUbB77bFZk/sUth+GYc9NI5ShQ=";
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
