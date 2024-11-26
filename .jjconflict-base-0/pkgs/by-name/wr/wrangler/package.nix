{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  pnpm_9,
  autoPatchelfHook,
  cacert,
  llvmPackages,
  musl,
  xorg,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wrangler";
  version = "3.80.1";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-sdk";
    rev = "wrangler@${finalAttrs.version}";
    hash = "sha256-9ClosoDIT+yP2dvNenHW2RSxLimOT3znXD+Pq+N6cQA=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-8EItfBV2n2rnXPCTYjDZlr/tdlEn8YOdIzOsj35w5gQ=";
  };

  buildInputs =
    [
      llvmPackages.libcxx
      llvmPackages.libunwind
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux) [
      musl # not used, but requires extra work to remove
      xorg.libX11 # for the clipboardy package
    ];

  nativeBuildInputs =
    [
      makeWrapper
      nodejs
      pnpm_9.configHook
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux) [
      autoPatchelfHook
    ];

  # @cloudflare/vitest-pool-workers wanted to run a server as part of the build process
  # so I simply removed it
  postBuild = ''
    rm -fr packages/vitest-pool-workers
    NODE_ENV="production" pnpm --filter workers-shared run build
    NODE_ENV="production" pnpm --filter miniflare run build
    NODE_ENV="production" pnpm --filter wrangler run build
  '';

  # I'm sure this is suboptimal but it seems to work. Points:
  # - when build is run in the original repo, no specific executable seems to be generated; you run the resulting build with pnpm run start
  # - this means we need to add a dedicated script - perhaps it is possible to create this from the workers-sdk dir, but I don't know how to do this
  # - the build process builds a version of miniflare which is used by wrangler; for this reason, the miniflare package is copied also
  # - pnpm stores all content in the top-level node_modules directory, but it is linked to from a node_modules directory inside wrangler
  # - as they are linked via symlinks, the relative location of them on the filesystem should be maintained
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib $out/lib/packages/wrangler
    rm -rf node_modules/typescript node_modules/eslint node_modules/prettier node_modules/bin node_modules/.bin node_modules/**/bin node_modules/**/.bin
    cp -r node_modules $out/lib
    cp -r packages/miniflare $out/lib/packages
    cp -r packages/workers-tsconfig $out/lib/packages
    cp -r packages/workers-shared $out/lib/packages
    cp -r packages/wrangler/node_modules $out/lib/packages/wrangler
    cp -r packages/wrangler/templates $out/lib/packages/wrangler
    cp -r packages/wrangler/wrangler-dist $out/lib/packages/wrangler
    rm -rf $out/lib/**/bin $out/lib/**/.bin
    cp -r packages/wrangler/bin $out/lib/packages/wrangler
    NODE_PATH_ARRAY=( "$out/lib/node_modules" "$out/lib/packages/wrangler/node_modules" )
    makeWrapper ${lib.getExe nodejs} $out/bin/wrangler \
      --inherit-argv0 \
      --prefix-each NODE_PATH : "$${NODE_PATH_ARRAY[@]}" \
      --add-flags $out/lib/packages/wrangler/bin/wrangler.js \
      --set-default SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt" # https://github.com/cloudflare/workers-sdk/issues/3264
    runHook postInstall
  '';

  meta = {
    description = "Command-line interface for all things Cloudflare Workers";
    homepage = "https://github.com/cloudflare/workers-sdk#readme";
    license = with lib.licenses; [
      mit
      apsl20
    ];
    maintainers = with lib.maintainers; [
      seanrmurphy
      dezren39
      ryand56
    ];
    mainProgram = "wrangler";
    # Tunneling and other parts of wrangler, which require workerd won't run on
    # other systems where precompiled binaries are not provided, but most
    # commands are will still work everywhere.
    # Potential improvements: build workerd from source instead.
    inherit (nodejs.meta) platforms;
  };
})
