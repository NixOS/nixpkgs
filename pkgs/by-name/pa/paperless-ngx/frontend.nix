{
  stdenv,
  lib,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs,
  node-gyp,
  pkg-config,
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
    fetcherVersion = 4;
    hash = "sha256-YYj6ZywzdQRyrCfTThbJz6gFiaiuYvXUzEpxvXT6zho=";
  };

  nativeBuildInputs = [
    node-gyp
    nodejs
    pkg-config
    pnpmConfigHook
    pnpm
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
