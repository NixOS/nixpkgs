{
  makeBinaryWrapper,
  nodejs,
  node-gyp,
  fetchPnpmDeps,
  fetchFromGitHub,
  pnpm_10,
  pnpmConfigHook,
  stdenv,
  lib,
  vips,
  pkg-config,
  python3,
  nix-update-script,
}:
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "papra";
  version = "26.4.0";

  src = fetchFromGitHub {
    owner = "papra-hq";
    repo = "papra";
    tag = "@papra/app@${finalAttrs.version}";
    hash = "sha256-wQdDBS+QRarZhEIRmLQ4VRtq73I5YFIN2P3ZtAZWvxw=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm;
    fetcherVersion = 3;
    hash = "sha256-8k8hzpyOQuHAPF+zzIhW+5vo6lHSyZeKAY+tYIf6jKU=";
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

    pnpm config set inject-workspace-packages true

    pushd node_modules/sharp
    pnpm run install
    popd

    pnpm --filter "@papra/app-client..." run build
    pnpm --filter "@papra/app-server..." run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}

    pnpm deploy --filter=@papra/app-server --prod $out/lib/

    mkdir -p $out/lib/public
    cp -r apps/papra-client/dist/* $out/lib/public/

    makeWrapper "${lib.getExe nodejs}" $out/bin/papra \
      --add-flags "$out/lib/dist/index.js" \
      --set "NODE_PATH" $out/lib/node_modules

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
