{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchzip,

  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "openlist-frontend";
  version = "4.1.10";

  src = fetchFromGitHub {
    owner = "OpenListTeam";
    repo = "OpenList-Frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V8nfQsGLhd7eERF0/ly3sRdGmffYa9r6GhtjciOXxMU=";
  };

  i18n = fetchzip {
    url = "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v${finalAttrs.version}/i18n.tar.gz";
    hash = "sha256-VdNqXdLXs2n/ikUDm1YQRNAXqYqFjMWRGLPRpmJVoaI=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_9
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    fetcherVersion = 2;
    hash = "sha256-xylF+Z7Fkx/bFYPlzqfGrl051ZLKzPgdlF7U8vKtQq8=";
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
