{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_11,
  nodejs-slim_22,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  nix-update-script,
  fetchpatch2,
}:
let
  # pnpm 11's bundled Node.js 24 has a libuv/kqueue bug on macOS, workaround copied from openclaw package
  pnpm = pnpm_11.override { nodejs-slim = nodejs-slim_22; };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "astro-language-server";
  version = "2.16.10";

  src = fetchFromGitHub {
    owner = "withastro";
    repo = "astro";
    tag = "@astrojs/language-server@${finalAttrs.version}";
    hash = "sha256-ZzLLGfbY6Rtjzqw+MMCHthvalo3B8lf/qxFJNJ/2LdQ=";
  };

  patches = [
    # remove on next release
    (fetchpatch2 {
      name = "fix-supply-chain-verification-fail.patch";
      url = "https://github.com/withastro/astro/commit/272ca6173b40cfa37299c27b513f495f386d4009.patch?full_index=1";
      includes = [ "pnpm-workspace.yaml" ];
      hash = "sha256-jPYFiyBlIoqpbIcT/hPa+VlF1IX+QCP8CVFQGarzlEs=";
    })
  ];

  # https://pnpm.io/filtering#--filter-package_name-1
  pnpmWorkspaces = [
    "@astrojs/language-server..."
    "@astrojs/ts-plugin"
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      patches
      ;
    inherit pnpm;
    # pnpm 11 stores state in a SQLite binary, fetcherVersion = 4 dumps it to a deterministic SQL text file
    fetcherVersion = 4;
    hash = "sha256-dqqvN8FMLjEbTtgQRkkURD7clMJ/OL9Mbk6icc4KU60=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  buildInputs = [ nodejs ];

  buildPhase = ''
    runHook preBuild

    pnpm --filter "@astrojs/language-server..." --filter "@astrojs/ts-plugin" build

    runHook postBuild
  '';

  env.CI = true;

  installPhase = ''
    runHook preInstall

    pnpm install --offline --prod --filter="@astrojs/language-server..."
    mkdir -p $out/{bin,lib/node_modules/astro-language-server/packages/language-tools}
    cp -r ./node_modules $out/lib/node_modules/astro-language-server
    cp -r packages/language-tools/{language-server,yaml2ts,ts-plugin} $out/lib/node_modules/astro-language-server/packages/language-tools/
    pushd $out/lib/node_modules/astro-language-server/node_modules
    rm -rf {./,.pnpm/node_modules/}astro-{scripts,benchmark} .pnpm/node_modules/@astrojs/ts-plugin
    popd
    # pnpm creates symlinks for optional platform-specific packages (e.g. @biomejs/cli-darwin-arm64)
    # that are not installed by the --prod --filter install, leaving dangling symlinks
    find $out -xtype l -delete
    ln -s $out/lib/node_modules/astro-language-server/packages/language-tools/language-server/bin/nodeServer.js $out/bin/astro-ls

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--use-github-releases"
      "--version-regex"
      "@astrojs/language-server@(.*)"
    ];
  };

  meta = {
    description = "Astro language server";
    homepage = "https://github.com/withastro/astro/tree/main/packages/language-tools";
    changelog = "https://github.com/withastro/astro/blob/%40astrojs/language-server%40${finalAttrs.version}/packages/language-tools/language-server/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      miniharinn
      god464
    ];
    mainProgram = "astro-ls";
    platforms = lib.platforms.unix;
  };
})
