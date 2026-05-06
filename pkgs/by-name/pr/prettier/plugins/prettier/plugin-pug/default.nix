/**
  ## Attributions

  - https://nixos.org/manual/nixpkgs/stable/#javascript-pnpm
  - https://nixos.org/manual/nixpkgs/stable/#javascript-pnpm-fetcherVersion
*/
{
  fetchFromGitHub,
  nodejs,
  pnpm_9,
  stdenv,
  ...
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prettier-plugin-pug";
  packageName = "@prettier/plugin-pug";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "prettier";
    repo = "plugin-pug";
    tag = finalAttrs.version;
    hash = "sha256-4CsKMj8Xnq+dlGzLAG2hV8jTCMYBYhaV/uoKAfztSGs=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
    pnpm_9
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    pnpm = pnpm_9;
    fetcherVersion = 2;
    hash = "sha256-4IS2dvcODzeakx8ezIQkoz6PLEP8Sm4OFz0EWQ0jXoA=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build:code

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r ./node_modules ./dist ./package.json $out/

    runHook postInstall
  '';

  doCheck = false;
  doInstallCheck = false;

  meta = {
    description = "Prettier Pug Plugin";
    homepage = "https://github.com/prettier/plugin-pug";
    license = "MIT";
  };
})
