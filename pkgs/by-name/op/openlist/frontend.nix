{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchzip,

  nodejs,
  pnpm_9,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "openlist-frontend";
  version = "4.1.5";

  src = fetchFromGitHub {
    owner = "OpenListTeam";
    repo = "OpenList-Frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J/6ZebKn7z5oagXF8in4PX9kMbdzBtqiwOgQdznYNzM=";
  };

  i18n = fetchzip {
    url = "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v${finalAttrs.version}/i18n.tar.gz";
    hash = "sha256-rpLHflA5EHxmc2ST0AhDnFOXbI5aE4jdedHOEFZ9+RY=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-Ge+uwFGvEtRgYf5zkwYbNfBONXoVxlw4pmu25nY4HTc=";
  };

  buildPhase = ''
    runHook preBuild

    cp -r ${finalAttrs.i18n}/* src/lang/
    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out
    echo -n "v${finalAttrs.version}" > $out/VERSION

    runHook postInstall
  '';

  meta = {
    description = "Frontend of OpenList";
    homepage = "https://github.com/OpenListTeam/OpenList-Frontend";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
})
