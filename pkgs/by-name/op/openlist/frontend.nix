{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchzip,

  nodejs,
  pnpm_10,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "openlist-frontend";
  version = "4.0.8";

  src = fetchFromGitHub {
    owner = "OpenListTeam";
    repo = "OpenList-Frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q/FZ9SMdNDPHmZlNeh8GcyRE6iwvI7X+Ic8InerjOps=";
  };

  i18n = fetchzip {
    url = "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v${finalAttrs.version}/i18n.tar.gz";
    hash = "sha256-Doomu3ZkHuUI2V4rRKo8XiOgzS4c35ealOb3iMI/RMg=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10.configHook
  ];

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-PTZ+Vhg3hNnORnulkzuVg6TF/jY0PvUWYja9z7S4GdM=";
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
