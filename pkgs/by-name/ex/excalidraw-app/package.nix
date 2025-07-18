{
  lib,
  stdenv,
  fetchYarnDeps,
  fetchFromGitHub,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "excalidraw-app";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "excalidraw";
    repo = "excalidraw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nfzh5rNvHP7R418PP44FXD7xNenzmzMHu7RLAdJsE/c=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-R3O/nHSp7gUC4tNAq7HoIY+k/5kgx5gew2uFOPAPWW8=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  yarnBuildScript = "build:app:docker";

  installPhase = ''
    runHook preInstall

    cp -r excalidraw-app/build $out

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/excalidraw/excalidraw/blob/${finalAttrs.src.tag}/packages/excalidraw/CHANGELOG.md";
    description = "Virtual whiteboard for sketching hand-drawn like diagrams";
    homepage = "https://github.com/excalidraw/excalidraw";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erdnaxe ];
  };
})
