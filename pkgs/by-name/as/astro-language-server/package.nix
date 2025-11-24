{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_10,
  nodejs,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "astro-language-server";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "withastro";
    repo = "astro";
    rev = "@astrojs/language-server@${finalAttrs.version}";
    hash = "sha256-95IsNW/ha4XsH0E0adX3x9N7ANDL6MZreXy//mIQk/I=";
  };

  # https://pnpm.io/filtering#--filter-package_name-1
  pnpmWorkspaces = [ "@astrojs/language-server..." ];
  prePnpmInstall = ''
    pnpm config set dedupe-peer-dependents false
    pnpm approve-builds @emmetio/css-parser
  '';

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      prePnpmInstall
      ;
    fetcherVersion = 2;
    hash = "sha256-LQpFnK+01SCyC4AHHHvdZlc6Ss40Lxq5+p9ioK10BSU=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10.configHook
  ];

  buildInputs = [ nodejs ];

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

    ln -s $out/lib/node_modules/astro-language-server/packages/language-tools/language-server/bin/nodeServer.js $out/bin/astro-ls

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "@astrojs/language-server@(.*)"
    ];
  };

  meta = {
    description = "Astro language server";
    homepage = "https://github.com/withastro/language-tools";
    changelog = "https://github.com/withastro/language-tools/blob/@astrojs/language-server@${finalAttrs.version}/packages/language-server/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "astro-ls";
    platforms = lib.platforms.unix;
  };
})
