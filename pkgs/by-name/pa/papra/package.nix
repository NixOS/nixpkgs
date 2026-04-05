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
}:
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "papra";
  version = "26.2.2";
  src = fetchFromGitHub {
    owner = "papra-hq";
    repo = "papra";
    tag = "@papra/app@${finalAttrs.version}";
    hash = "sha256-0MIar+fBwXRE8LlVLZDx/C0GOYVpobDTqFwkMs2k06Y=";
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

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm;
    fetcherVersion = 3;
    hash = "sha256-NQakyRlL6deG13yt+FlmVcVvEkNWHW0Lhf/3NecfwaE=";
    pnpmWorkspaces = [
      "@papra/app-client..."
      "@papra/app-server..."
    ];
  };

  meta = {
    description = "Open-source document management platform designed to help you organize, secure, and archive your files effortlessly.";
    homepage = "https://papra.app/";
    changelog = "https://github.com/papra-hq/papra/releases";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ wariuccio ];
  };
})
