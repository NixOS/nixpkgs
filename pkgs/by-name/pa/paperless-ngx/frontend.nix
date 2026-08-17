{
  stdenv,
  lib,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs,
  node-gyp,
  pkg-config,
  python3,
  pango,
  giflib,
  xcbuild,
  src,
  version,
  meta,
}:
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "paperless-ngx-frontend";
  inherit version;

  src = src + "/src-ui";

  pnpmDeps = fetchPnpmDeps {
    inherit pnpm;
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-HO+IDNB3NXWgvV0cvZ5zx46JuXv6Tgroz+YfVump5MA=";
  };

  nativeBuildInputs = [
    node-gyp
    nodejs
    pkg-config
    pnpmConfigHook
    pnpm
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild
  ];

  buildInputs = [
    pango
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    giflib
  ];

  CYPRESS_INSTALL_BINARY = "0";
  NG_CLI_ANALYTICS = "false";

  buildPhase = ''
    runHook preBuild

    pushd node_modules/canvas
    node-gyp rebuild
    popd

    # cat forcefully disables angular cli's spinner which doesn't work with nix' tty which is 0x0
    pnpm run build --configuration production | cat

    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    pnpm run test | cat

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/paperless-ui
    mv ../src/documents/static/frontend $out/lib/paperless-ui/

    runHook postInstall
  '';

  inherit meta;
})
