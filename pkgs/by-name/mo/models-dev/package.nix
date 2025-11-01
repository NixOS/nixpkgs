{
  lib,
  stdenvNoCC,
  bun,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "models-dev";
  version = "0-unstable-2025-10-31";
  src = fetchFromGitHub {
    owner = "sst";
    repo = "models.dev";
    rev = "91a03818a6eb45508d042c91cb4cf21a331296f1";
    hash = "sha256-cjyGeTLfv8CpW8OuyPDG3KKYJ6N7u2EUhMFTGTGOIPM=";
  };

  node_modules = stdenvNoCC.mkDerivation {
    pname = "models-dev-node_modules";
    inherit (finalAttrs) version src;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

       export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

       # NOTE: Starting with Bun 1.3.0, isolated builds became the default
       # behavior. In isolated builds, each package receives its own
       # `.node_modules` subdirectory containing only the dependencies
       # explicitly declared in that package's `package.json`. Since our build
       # process copies only the root-level `.node_modules` directory, we must
       # use `--linker=hoisted` to consolidate all dependencies there. Without
       # this flag, we would need to copy every individual `.node_modules`
       # subdirectory from each package.
       bun install \
         --force \
         --frozen-lockfile \
         --linker=hoisted \
         --no-progress \
         --production

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/node_modules
      cp -R ./node_modules $out

      runHook postInstall
    '';

    # Required else we get errors that our fixed-output derivation references store paths
    dontFixup = true;

    outputHash =
      {
        x86_64-linux = "sha256-Uajwvce9EO1UwmpkGrViOrxlm2R/VnnMK8WAiOiQOhY=";
        aarch64-linux = "sha256-brjdEEYBJ1R5pIkIHyOOmVieTJ0yUJEgxs7MtbzcKXo=";
        x86_64-darwin = "sha256-aGUWZwySmo0ojOBF/PioZ2wp4NRwYyoaJuytzeGYjck=";
        aarch64-darwin = "sha256-IM88XPfttZouN2DEtnWJmbdRxBs8wN7AZ1T28INJlBY=";
      }
      .${stdenvNoCC.hostPlatform.system};
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [ bun ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules}/node_modules .

    runHook postConfigure
  '';

  preBuild = ''
    patchShebangs packages/web/script/build.ts
  '';

  buildPhase = ''
    runHook preBuild

    cd packages/web
    bun run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/dist
    cp -R ./dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Comprehensive open-source database of AI model specifications, pricing, and capabilities";
    homepage = "https://github.com/sst/models-dev";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ delafthi ];
  };
})
