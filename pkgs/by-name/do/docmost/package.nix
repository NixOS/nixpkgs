{
  lib,
  callPackage,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm,
  faketty,
  makeBinaryWrapper,
  jq,
}:
let
  bcrypt-lib = callPackage ./bcrypt-lib.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "docmost";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "docmost";
    repo = "docmost";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-IsnPIltC+xvkzqcioX4SLEcIBK3z+prlSQkgLfhsR8k=";
  };

  outputs = [
    "out"
    "client"
  ];

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
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

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    hash = "sha256-L3+eUwwoXPUYV9NIuG3MmqZH9gIsQJmu8zGIy/v2oF0=";
  };

  buildPhase = ''
    runHook preBuild

    faketty pnpm nx run @docmost/editor-ext:build
    faketty pnpm build

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $client
    cp -r apps/client/dist $client

    mkdir -p $out/bin
    cp -r apps/server/dist $out/dist
    cp -r node_modules $out/node_modules

    makeWrapper ${lib.getExe nodejs} $out/bin/docmost \
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
    maintainers = with lib.maintainers; [ pluiedev ];
    inherit (nodejs.meta) platforms;
    mainProgram = "docmost";
  };
})
