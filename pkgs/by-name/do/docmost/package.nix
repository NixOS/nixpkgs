{
  lib,
  callPackage,
  stdenv,
  fetchFromGitHub,
  nodejs_26,
  pnpm_12,
  fetchPnpmDeps,
  pnpmConfigHook,
  faketty,
  makeBinaryWrapper,
  jq,
}:
let
  bcrypt-lib = callPackage ./bcrypt-lib.nix { };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "docmost";
  version = "0.97.0";

  src = fetchFromGitHub {
    owner = "docmost";
    repo = "docmost";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-dLueq/8dmhjQnvsPsCmsmnll32JIOI5+sOFhFh19J+Y=";
  };
  postPatch = ''
    substituteInPlace pnpm-workspace.yaml pnpm-lock.yaml \
      --replace-fail "patchedDependencies:" "patchedDependencies:"
  '';

  outputs = [
    "out"
    "client"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    nodejs_26
    pnpmConfigHook
    pnpm_12
    # See https://github.com/nrwl/nx/issues/22445 for why this is necessary
    faketty
    makeBinaryWrapper
    jq
  ];

  pnpmWorkspaces = [
    "@docmost/editor-ext"
    "client"
    "server"
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_12;
    fetcherVersion = 4;
    hash = "sha256-ONx4lcG5xRu43fv+mfugJ5PcnqiIM6wYf/yG4LH4fwI=";
  };

  buildPhase = ''
    runHook preBuild

    faketty pnpm install --no-frozen-lockfile
    faketty pnpm exec nx run @docmost/editor-ext:build
    faketty pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $client
    cp -r apps/client/dist $client
    mkdir -p $out/apps
    cp -r apps/client $out/apps/client

    mkdir -p $out/apps
    cp -r apps/server $out/apps/server

    mkdir -p $out/packages
    cp -r packages/base-formula $out/packages/base-formula
    cp -r packages/editor-ext $out/packages/editor-ext

    mkdir -p $out/bin
    cp -r apps/server/dist $out/dist
    cp -r node_modules $out/node_modules

    makeWrapper ${lib.getExe nodejs_26} $out/bin/docmost \
      --add-flags "$out/dist/main.js"
  '';

  postFixup = ''
    # Fix bcrypt node module
    install -D ${bcrypt-lib}/lib/binding/napi-v3/bcrypt_lib.node -t $out/node_modules/.pnpm/bcrypt@${bcrypt-lib.version}/node_modules/bcrypt/lib/binding/napi-v3
  '';

  passthru.bcrypt-lib = bcrypt-lib;

  meta = {
    description = "https://docmost.com/";
    homepage = "https://github.com/docmost/docmost";
    changelog = "https://github.com/docmost/docmost/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ agpl3Only ];
    maintainers = with lib.maintainers; [
      pluiedev
      thegrayarea
    ];
    inherit (nodejs_26.meta) platforms;
    mainProgram = "docmost";
  };
})
