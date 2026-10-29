{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  stdenv,
  makeWrapper,
  nodejs,
  npm-lockfile-fix,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "nextcloud-whiteboard-server";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "whiteboard";
    tag = "v${finalAttrs.version}";
    postFetch = ''
      # Requested upstream: https://github.com/nextcloud/whiteboard/pull/1421
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
    hash = "sha256-bik/Ek/F8n+6E0IxTOO0e7q0rx6TRLKV9NAyGRB0q38=";
  };

  npmDepsHash = "sha256-OK19edJMOLmnq4ZN+r5oyCJhi6TXfYMNuPj2tNOYu4s=";

  npmFlags = [ "--legacy-peer-deps" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    makeWrapper ${lib.getExe nodejs} "$out/bin/nextcloud-whiteboard-server" \
      --add-flags "$out/lib/node_modules/whiteboard/websocket_server/main.js"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Backend server for the Nextcloud Whiteboard app";
    homepage = "https://apps.nextcloud.com/apps/whiteboard";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.onny ];
    mainProgram = "nextcloud-whiteboard-server";
  };
})
