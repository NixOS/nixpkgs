{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  nodejs,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  ffmpeg,
  onnxruntime,
  makeWrapper,
  nixosTests,
}:
let
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bookorbit-read-aloud-worker";
  version = "3.6.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "bookorbit";
    repo = "bookorbit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IVBq4XnXS6AY6YoJanlf2yg7g3d9XMqWIcxA8LMCs4k=";
  };

  pnpmWorkspaces = [
    "server..."
    "client..."
    "@bookorbit/read-aloud-worker"
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-+xgLRlqOxSCGvEjGT+x6iu+C7n8wrJf7mIc3TqV1iTM=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    ffmpeg
    onnxruntime
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    export CI=1
    pnpm --filter @bookorbit/types build

    export ONNXRUNTIME_NODE_INSTALL="skip"
    pnpm --filter @bookorbit/read-aloud-worker build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    pnpm --filter @bookorbit/read-aloud-worker \
         --config.inject-workspace-packages=true \
         --prod \
         deploy $out/lib

    makeWrapper ${nodejs}/bin/node $out/bin/bookorbit-read-aloud-worker \
      --run "cd $out/lib" \
      --set NODE_ENV production \
      --add-flags "$out/lib/dist/main.js"

    runHook postInstall
  '';

  postInstall = ''
    rm -rf "$out/lib/node_modules/onnxruntime-node/bin/napi-v6/win32"
    rm -rf ${
      lib.concatStringsSep " " (
        (lib.optional (
          !stdenv.hostPlatform.isx86_64
        ) "$out/lib/node_modules/onnxruntime-node/bin/napi-v6/*/x64")
        ++ (lib.optional (
          !stdenv.hostPlatform.isAarch64
        ) "$out/lib/node_modules/onnxruntime-node/bin/napi-v6/*/arm64")
        ++ (lib.optional (
          !stdenv.hostPlatform.isDarwin
        ) "$out/lib/node_modules/onnxruntime-node/bin/napi-v6/darwin")
        ++ (lib.optional (
          !stdenv.hostPlatform.isLinux
        ) "$out/lib/node_modules/onnxruntime-node/bin/napi-v6/linux")
      )
    }
  '';

  passthru = {
    #tests = {
    #  inherit (nixosTests) bookorbit;
    #};

    updateScript = nix-update-script { };
  };

  meta = {
    description = "BookOrbit worker to generate read-aloud epubs.";
    homepage = "https://github.com/bookorbit/bookorbit";
    changelog = "https://github.com/bookorbit/bookorbit/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ dstengele ];
    mainProgram = "bookorbit-read-aloud-worker";
    platforms = lib.platforms.all;
  };
})
