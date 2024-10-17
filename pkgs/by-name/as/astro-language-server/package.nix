{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm,
  nodejs_22,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "astro-language-server";
  version = "2.15.3";

  src = fetchFromGitHub {
    owner = "withastro";
    repo = "language-tools";
    rev = "@astrojs/language-server@${finalAttrs.version}";
    hash = "sha256-PJTcr/FIA0haatLFNHMJV24j6eK+c2DR9zpnR8aReHo=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspace
      prePnpmInstall
      ;
    hash = "sha256-/X8ZoWK5kBPm/8clBDP+B9A5ofXnH2svmy4kMc2t5iA=";
  };

  nativeBuildInputs = [
    nodejs_22
    pnpm.configHook
  ];

  buildInputs = [ nodejs_22 ];

  # Must specify to download "@astrojs/yaml2ts" depencendies
  # https://pnpm.io/filtering#--filter-package_name-1
  pnpmWorkspace = "@astrojs/language-server...";
  prePnpmInstall = ''
    # Warning section for "pnpm@v8"
    # https://pnpm.io/cli/install#--filter-package_selector
    pnpm config set dedupe-peer-dependents false
  '';

  buildPhase = ''
    runHook preBuild

    # Must build the "@astrojs/yaml2ts" package. Dependency is linked via workspace by "pnpm"
    # (https://github.com/withastro/language-tools/blob/%40astrojs/language-server%402.14.2/pnpm-lock.yaml#L78-L80)
    pnpm --filter "@astrojs/language-server..." build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/astro-language-server}
    cp -r {packages,node_modules} $out/lib/astro-language-server
    ln -s $out/lib/astro-language-server/packages/language-server/bin/nodeServer.js $out/bin/astro-ls

    runHook postInstall
  '';

  meta = {
    description = "The Astro language server";
    homepage = "https://github.com/withastro/language-tools";
    changelog = "https://github.com/withastro/language-tools/blob/@astrojs/language-server@${finalAttrs.version}/packages/language-server/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "astro-ls";
    platforms = lib.platforms.unix;
  };
})
