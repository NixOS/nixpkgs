{
  lib,
  stdenvNoCC,
  bun,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

let
  models-dev-node-modules-hash = {
    "aarch64-darwin" = "sha256-IM88XPfttZouN2DEtnWJmbdRxBs8wN7AZ1T28INJlBY=";
    "aarch64-linux" = "sha256-brjdEEYBJ1R5pIkIHyOOmVieTJ0yUJEgxs7MtbzcKXo=";
    "x86_64-darwin" = "sha256-aGUWZwySmo0ojOBF/PioZ2wp4NRwYyoaJuytzeGYjck=";
    "x86_64-linux" = "sha256-Uajwvce9EO1UwmpkGrViOrxlm2R/VnnMK8WAiOiQOhY=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "models-dev";
  version = "0-unstable-2025-08-21";
  src = fetchFromGitHub {
    owner = "sst";
    repo = "models.dev";
    rev = "7d417bd1b54bfff3c63f2bc2cc486e6b2700a18d";
    hash = "sha256-9p+Fc21slH0R7YLJOAlVPS+ZPv+I9j745lGYz6+ln/c=";
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

       bun install \
         --force \
         --frozen-lockfile \
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

    outputHash = models-dev-node-modules-hash.${stdenvNoCC.hostPlatform.system};
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [ bun ];

  patches = [
    # In bun 1.2.13 (release-25.05) HTML entrypoints get content hashes
    # appended → index.html becomes index-pq8vj7za.html in ./dist. So, we
    # rename the index file back to index.html
    ./post-build-rename-index-file.patch
  ];

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
