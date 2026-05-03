{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "astro-language-server";
  version = "2.16.7";

  src = fetchFromGitHub {
    owner = "withastro";
    repo = "astro";
    tag = "@astrojs/language-server@${finalAttrs.version}";
    hash = "sha256-0UkbHGOvMJxY4RXVLx9T8oh2cnuwziEuwUfFrls4Wc0=";
  };

  # https://pnpm.io/filtering#--filter-package_name-1
  pnpmWorkspaces = [
    "@astrojs/language-server..."
    "@astrojs/ts-plugin"
  ];
  prePnpmInstall = ''
    pnpm config set dedupe-peer-dependents false
    pnpm approve-builds @emmetio/css-parser
  '';

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      prePnpmInstall
      ;
    pnpm = pnpm_10;
    fetcherVersion = 2;
    hash = "sha256-DFoIq5+cKqnmWLJ6CHhfdQEAGjvpu72qb1CSWaExODI=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
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
