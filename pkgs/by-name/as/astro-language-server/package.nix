{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_8,
  nodejs_22,
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

  pnpmDeps = pnpm_8.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspace
      prePnpmInstall
      ;
    hash = "sha256-n7HTd/rKxJdQKnty5TeOcyvBU9j/EClQ9IHqbBaEwQE=";
  };

  nativeBuildInputs = [
    nodejs_22
    pnpm_8.configHook
  ];

  buildInputs = [ nodejs_22 ];

  pnpmWorkspace = "@astrojs/language-server";
  prePnpmInstall = ''
    pnpm config set dedupe-peer-dependents false
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
