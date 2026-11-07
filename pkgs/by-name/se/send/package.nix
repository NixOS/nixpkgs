{
  lib,
  buildNpmPackage,
  common-updater-scripts,
  esbuild,
  fetchFromGitHub,
  fetchFromGitLab,
  jq,
  makeBinaryWrapper,
  nix,
  nodejs,
  nix-update,
  nixosTests,
  writeShellApplication,
}:
buildNpmPackage (finalAttrs: {
  pname = "send";
  version = "3.5.0";

  src = fetchFromGitLab {
    owner = "timvisee";
    repo = "send";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zdCyCAr7Ex983OzUwl+YTZSfopZRdpNLUISOlag5PuQ=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-zYRl/8kMMiI6D2TARvqK6ebYBzICJFCgw3HaM8pPUcs=";

  nativeBuildInputs = [
    esbuild
    makeBinaryWrapper
  ];

  postConfigure = ''
    esbuild ${finalAttrs.passthru.webcryptoCoreSrc}/src/index.ts \
      --bundle --format=cjs --target=es2015 --external:tslib \
      --outfile=node_modules/webcrypto-core/dist/webcrypto-core.js
    esbuild ${finalAttrs.passthru.webcryptoCoreSrc}/src/index.ts \
      --bundle --format=esm --target=es2015 --external:tslib \
      --outfile=node_modules/webcrypto-core/dist/webcrypto-core.es.js
  '';

  env = {
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = "true";
    NODE_OPTIONS = "--openssl-legacy-provider";
  };

  npmPackFlags = [ "--ignore-scripts" ];

  postInstall = ''
    cp -r dist $out/lib/node_modules/send/
    ln -s $out/lib/node_modules/send/dist/version.json $out/lib/node_modules/send/version.json

    makeWrapper ${lib.getExe nodejs} $out/bin/send \
      --add-flags $out/lib/node_modules/send/server/bin/prod.js \
      --set "NODE_ENV" "production"
  '';

  passthru = {
    # The pinned fork adds HKDF support that the registry package lacks.
    webcryptoCoreSrc = fetchFromGitHub {
      owner = "dannycoates";
      repo = "webcrypto-core";
      rev = "8e0152a66d3ae6329cf080ccb3085eb06637070f";
      hash = "sha256-J7ffgORz21qUeY2rc/SrGipkJuRWVPkG9RensfklsWE=";
    };

    updateScript = lib.getExe (writeShellApplication {
      name = "send-update";
      runtimeInputs = [
        common-updater-scripts
        jq
        nix
        nix-update
      ];
      text = ''
        nix-update send "$@"
        src=$(nix-build --no-out-link -A send.src)
        rev=$(jq -er '.packages["node_modules/webcrypto-core"].resolved | capture("#(?<rev>[0-9a-f]{40})$").rev' "$src/package-lock.json")
        currentRev=$(nix-instantiate --eval --json -A send.webcryptoCoreSrc.rev | jq -r .)
        if [[ "$rev" != "$currentRev" ]]; then
          update-source-version send --ignore-same-version --source-key=webcryptoCoreSrc --rev="$rev"
        fi
      '';
    });

    tests = {
      inherit (nixosTests) send;
    };
  };

  meta = {
    description = "File Sharing Experiment";
    changelog = "https://gitlab.com/timvisee/send/-/tags/v${finalAttrs.version}";
    homepage = "https://gitlab.com/timvisee/send";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      moraxyc
      MrSom3body
    ];
    mainProgram = "send";
  };
})
