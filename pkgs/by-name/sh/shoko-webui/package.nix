{
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  pnpm,
  lib,
  shokoserver,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "Shoko-WebUI";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "ShokoAnime";
    repo = "Shoko-WebUI";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mX5IUv13Kr07OsWzQxgxjC2P1GUBwe/5Po8Qd7hL0HI=";
  };

  # Avoid requiring git as a build time dependency. It's used for version
  # checking in the updater, which shouldn't be used if the webui is managed
  # declaratively anyway.
  patches = [ ./no-commit-hash.patch ];

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Fnv54QmVGwcUqKTv6igdSV51vXsHphho4sJQeKoyFVU=";
  };

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cp -r dist $out
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/ShokoAnime/Shoko-WebUI";
    description = "Web-based frontend for the Shoko anime management system";
    maintainers = [ lib.maintainers.diniamo ];
    inherit (shokoserver.meta) license platforms;
  };
})
