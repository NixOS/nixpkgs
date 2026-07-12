{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  nix-update-script,
}:
let
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "astro-language-server";
  version = "2.16.11";

  src = fetchFromGitHub {
    owner = "withastro";
    repo = "astro";
    tag = "@astrojs/language-server@${finalAttrs.version}";
    hash = "sha256-FbgxlXW87vMionLpN1IRztmq4iPoARsBZ8SO9axEbCc=";
  };

  # https://pnpm.io/filtering#--filter-package_name-1
  pnpmWorkspaces = [ "@astrojs/language-server..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;

    # pnpm 11 stores state in a SQLite binary, fetcherVersion = 4 dumps it to a deterministic SQL text file
    fetcherVersion = 4;
    hash = "sha256-U2K0uF0D3HyY1fLxpoPtMmNEFT7DKllRsFcgknVDt6Y=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  buildPhase = ''
    runHook preBuild

    pnpm --filter "@astrojs/language-server..." build

    runHook postBuild
  '';

  env.CI = true;

  installPhase = ''
    runHook preInstall

    pnpm install --offline --prod --filter="@astrojs/language-server..."
    mkdir -p $out/{bin,lib/node_modules/astro-language-server/packages/language-tools}
    cp -r ./node_modules $out/lib/node_modules/astro-language-server
    cp -r packages/language-tools/{language-server,yaml2ts} $out/lib/node_modules/astro-language-server/packages/language-tools/
    pushd $out/lib/node_modules/astro-language-server/node_modules
    rm -rf {./,.pnpm/node_modules/}astro-{scripts,benchmark}
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
