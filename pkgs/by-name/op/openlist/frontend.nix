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
  version = "4.0.0-rc.4";

  src = fetchFromGitHub {
    owner = "OpenListTeam";
    repo = "OpenList-Frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZAEaGFOWzL3apV6KXokLV8GGhmp9C38npUhBngdPbq0=";
  };

  i18n = fetchzip {
    url = "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v${finalAttrs.version}/i18n.tar.gz";
    hash = "sha256-AzH1rZFqEH8sovZZfJykvsEmCedEZWigQFHWHl6/PiE=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10.configHook
  ];

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-4NKzy4q6DjWgTL63WBEeDxjAsrgcM5vfHqtmZpS5dug=";
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
