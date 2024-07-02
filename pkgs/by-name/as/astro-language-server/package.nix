{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_8,
  nodejs_22,
  jq,
  moreutils,
  cacert,
  stdenvNoCC,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "astro-language-server";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "withastro";
    repo = "language-tools";
    rev = "@astrojs/language-server@${finalAttrs.version}";
    hash = "sha256-WdeQQaC9AVHT+/pXLzaC6MZ6ddHsFSpxoDPHqWvqmiQ=";
  };

  pnpmDeps = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-pnpm-deps";
    inherit (finalAttrs) src version;

    nativeBuildInputs = [
      jq
      moreutils
      pnpm_8
      cacert
    ];

    installPhase = ''
      export HOME=$(mktemp -d)
      pnpm config set store-dir $out
      pnpm config set side-effects-cache false
      pnpm config set update-notifier false
      pnpm config set dedupe-peer-dependents false
      pnpm install --filter=@astrojs/language-server --frozen-lockfile --no-optional --ignore-script --force

      # Remove timestamp and sort the json files
      rm -rf $out/v3/tmp
      for f in $(find $out -name "*.json"); do
        sed -i -E -e 's/"checkedAt":[0-9]+,//g' $f
        jq --sort-keys . $f | sponge $f
      done
    '';

    dontConfigure = true;
    dontFixup = true;
    dontBuild = true;
    outputHashMode = "recursive";
    outputHash = "sha256-v88a/NB7geQf4r9fNqV1qkq9m/uATqcS1l0ljgy4Fdg=";
  };
  nativeBuildInputs = [
    nodejs_22
    pnpm_8
  ];

  buildInputs = [
    nodejs_22
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
    pnpm config set store-dir ${finalAttrs.pnpmDeps}
    pnpm config set recursive-install false
    pnpm config set package-manager-strict false
    pnpm config set dedupe-peer-dependents false

    pnpm install --filter=@astrojs/language-server --offline --frozen-lockfile --no-optional --ignore-script
    patchShebangs node_modules/{*,.*}
  '';

  buildPhase = ''
    runHook preBuild

    pnpm --filter=@astrojs/language-server build

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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "astro-ls";
    platforms = lib.platforms.unix;
  };
})
