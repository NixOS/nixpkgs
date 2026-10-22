{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  npm-lockfile-fix,
  nix-update-script,
  fetchNextcloudApp,
}:
buildNpmPackage (finalAttrs: {
  pname = "nextcloud-whiteboard-server";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "whiteboard";
    tag = "v${finalAttrs.version}";
    postFetch = ''
      # Requested upstream: https://github.com/nextcloud/whiteboard/pull/1421
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
    hash = "sha256-MlJHLiql2gGmUjNNPehkRTW4iQqTW5DL43+t1Wis6ys=";
  };

  npmDepsHash = "sha256-4zallneSkRAiJqyWhkkzHkQ55wi4Uf5RdHS8tc1KbLc=";

  npmFlags = [ "--legacy-peer-deps" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    makeWrapper ${lib.getExe nodejs} "$out/bin/nextcloud-whiteboard-server" \
      --add-flags "$out/lib/node_modules/whiteboard/websocket_server/main.js"
  '';

  passthru.app = fetchNextcloudApp {
    appName = "whiteboard";
    appVersion = finalAttrs.version;
    hash = "sha256-4JWPiSvy8Xmv7mhepHD4EwzgoAk6kiIaiLpKntLSheM=";
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
