{
  makeBinaryWrapper,
  nodejs_26,
  nodejs-slim_26,
  node-gyp,
  fetchPnpmDeps,
  fetchFromGitHub,
  pnpm_11,
  pnpmConfigHook,
  stdenv,
  lib,
  vips,
  pkg-config,
  python3,
  nix-update-script,
  tsx,
}:
let
  pnpm = pnpm_11.override { nodejs-slim = nodejs-slim_26; };
  nodejs = nodejs_26;
  tsx' = tsx.override { nodejs-slim_24 = nodejs-slim_26; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "papra";
  version = "26.5.0";

  src = fetchFromGitHub {
    owner = "papra-hq";
    repo = "papra";
    tag = "@papra/app@${finalAttrs.version}";
    hash = "sha256-BOeApLfB1NR07izBM3ChHqzgGx3xf1NkAXqKVeMzqx4=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm;
    fetcherVersion = 4;
    hash = "sha256-J1syB5X+sI40iPlqDVABqeWDiBjKGP3qQRIh5w3GRUU=";
    pnpmWorkspaces = [
      "@papra/app-client..."
      "@papra/app-server..."
    ];
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    node-gyp
    python3
    pkg-config
    pnpmConfigHook
    pnpm
  ];

  buildInputs = [
    vips
  ];

  env.SHARP_FORCE_GLOBAL_LIBVIPS = 1;
  env.npm_config_nodedir = nodejs;

  postPatch = ''
    substituteInPlace apps/papra-server/src/modules/app/static-assets/static-assets.routes.ts \
      --replace-fail "./public" "$out/lib/public" \
      --replace-fail "public/index.html" "$out/lib/public/index.html"
  '';

  buildPhase = ''
    runHook preBuild

    pnpm --filter "@papra/app-client..." run build
    pnpm --filter "@papra/app-server..." run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}

    pnpm config set --location=project injectWorkspacePackages true
    pnpm deploy --ignore-script --filter=@papra/app-server --prod $out/lib/

    mkdir -p $out/lib/public
    cp -r apps/papra-client/dist/* $out/lib/public/

    makeWrapper "${lib.getExe nodejs}" $out/bin/papra \
      --add-flags "$out/lib/dist/index.js" \
      --set "NODE_PATH" $out/lib/node_modules

    makeWrapper "${lib.getExe tsx'}" $out/bin/papra-migrate-up \
      --add-flags "$out/lib/src/scripts/migrate-up.script.ts"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source document management platform designed to help you organize, secure, and archive your files effortlessly.";
    homepage = "https://papra.app/";
    changelog = "https://github.com/papra-hq/papra/releases";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      wariuccio
      miniharinn
    ];
  };
})
