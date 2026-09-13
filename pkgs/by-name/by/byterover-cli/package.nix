{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
  makeBinaryWrapper,
  versionCheckHook,
}:

let
  nodejs = nodejs_24;

  # `dist/` is gitignored, built by its `prepare` script.
  # `npm ci --ignore-scripts` skips that, so the CLI can't resolve it.
  # Build it separately and inject the dist/ back in.
  brvTransportClient = buildNpmPackage.override { inherit nodejs; } {
    pname = "brv-transport-client";
    version = "1.1.0";

    src = fetchFromGitHub {
      owner = "campfirein";
      repo = "brv-transport-client";
      rev = "ad0a0029875e4c952c8c6ba58c224f4ce37c80d7";
      hash = "sha256-x87OPBTUz2CLRlC+aYwPUkvwnPE1clUfs8d1QhnKT+w=";
    };

    npmDepsHash = "sha256-Qe/qqUXNjdkSQG3311gMeZlNjJvvDzUIOa5L1qHz8Zw=";
  };
in
buildNpmPackage.override { inherit nodejs; } (finalAttrs: {
  pname = "byterover-cli";
  version = "3.16.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "campfirein";
    repo = "byterover-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p2sSvlL8zUd4k3ex0Am0Tds5jwbmrtoZmoLRPt+fidM=";
  };

  npmDepsHash = "sha256-a4RkrA8GAb0jMlno+XRqjFUjq09PPXBJnKYQrnshSnc=";

  # Structured attrs don't export stdenv; the git-dep patchShebangs hook needs it.
  postPatch = ''
    export stdenv
  '';

  # `npm ci` writes to the prefetched cache, it must be writable.
  makeCacheWritable = true;

  # Deterministic Vite/tailwind/react builds in CI
  env.CI = "1";

  nativeBuildInputs = [ makeBinaryWrapper ];

  # `npm ci --ignore-scripts` leaves this dir empty; use the pre-built copy.
  preBuild = ''
    rm -rf node_modules/@campfirein/brv-transport-client
    cp -r \
      ${brvTransportClient}/lib/node_modules/@campfirein/brv-transport-client \
      node_modules/@campfirein/brv-transport-client
  '';

  # `oclif` reads `package.json` from parent of `bin/run.js` for config + version.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/byterover
    cp -r dist $out/lib/byterover/dist
    cp -r bin $out/lib/byterover/bin
    cp -r node_modules $out/lib/byterover/node_modules
    cp package.json $out/lib/byterover/package.json

    makeBinaryWrapper ${nodejs}/bin/node $out/bin/brv \
      --add-flags "$out/lib/byterover/bin/run.js" \
      --set BRV_DISABLE_AUTOUPDATE 1 \
      --set BRV_REDIRECTED 1

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "The portable memory layer for autonomous coding agents (formerly Cipher)";
    homepage = "https://byterover.dev";
    # https://github.com/campfirein/byterover-cli/blob/main/LICENSE
    license = lib.licenses.elastic20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ knightfemale ];
    mainProgram = "brv";
  };
})
