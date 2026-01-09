{
  fetchFromGitHub,
  lib,
  nodejs,
  fetchPnpmDeps,
  pnpm_9,
  pnpmConfigHook,
  stdenv,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prettier-plugin-astro";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "withastro";
    repo = "prettier-plugin-astro";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XGPz4D2UKOonet0tX3up5mCxw3/69XYPScxb9l7nzpE=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_9
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = finalAttrs.pnpmDepsHash;
  };

  pnpmDepsHash = "sha256-K7pIWLkIIbUKDIcysfEtcf/eVMX9ZgyFHdqcuycHCNE=";

  passthru.update-script = nix-update-script { };

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/node_modules/prettier-plugin-astro/dist
    cp -r dist/* $out/lib/node_modules/prettier-plugin-astro/dist
    cp -r node_modules $out/lib/node_modules/prettier-plugin-astro/node_modules
    cp package.json $out/lib/node_modules/prettier-plugin-astro/package.json
    cp README.md $out/lib/node_modules/prettier-plugin-astro/README.md
    runHook postInstall
  '';

  meta = with lib; {
    description = "Prettier plugin for Astro";
    homepage = "https://github.com/withastro/prettier-plugin-astro";
    changelog = "https://github.com/withastro/prettier-plugin-astro/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [ shikanime ];
  };
})
