{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  nix-update-script,
  fetchNextcloudApp,
}:
buildNpmPackage (finalAttrs: {
  pname = "nextcloud-whiteboard-server";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "whiteboard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xL2ZCG10/73DAkOgvPrssm7Mty5aJ1juVkcLle/g4oI=";
  };

  npmDepsHash = "sha256-JVdoHbkF+l+Ed8t6kuEk5UCIUMO16yGjmuG6eWCZwww=";

  npmFlags = [ "--legacy-peer-deps" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    makeWrapper ${lib.getExe nodejs} "$out/bin/nextcloud-whiteboard-server" \
      --add-flags "$out/lib/node_modules/whiteboard/websocket_server/main.js"
  '';

  passthru.app = fetchNextcloudApp {
    appName = "whiteboard";
    appVersion = finalAttrs.version;
    hash = "sha256-uj29Wz8aDTSvNoMFrHf9oGMwdFe4vRQ5Vcw1k9DO7r0=";
    license = "agpl3Plus";
    homepage = "https://github.com/nextcloud/whiteboard";
    url = "https://github.com/nextcloud-releases/whiteboard/releases/download/v${finalAttrs.version}/whiteboard-v${finalAttrs.version}.tar.gz";
    description = "Whiteboard app";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--custom-dep"
      "app"
    ];
  };

  meta = {
    description = "Backend server for the Nextcloud Whiteboard app";
    homepage = "https://apps.nextcloud.com/apps/whiteboard";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.onny ];
    mainProgram = "nextcloud-whiteboard-server";
  };
})
