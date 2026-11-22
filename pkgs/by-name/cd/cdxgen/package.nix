{
  cctools,
  fetchFromGitHub,
  lib,
  makeWrapper,
  nodejs,
  pnpm_12,
  fetchPnpmDeps,
  pnpmConfigHook,
  stdenv,

  # tests
  runCommand,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cdxgen";
  version = "13.7.0";

  src = fetchFromGitHub {
    owner = "cdxgen";
    repo = "cdxgen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Eb16kAfv0V3qK53DzTZywhIsGm0WaaZq55Xbr0UnZ08=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpmConfigHook
    pnpm_12
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin cctools.libtool;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_12;
    fetcherVersion = 5;
    hash = "sha256-25R8YQ115BvNiC8nmDpfDyiExeTXkfIDLmnw+yoXPuQ=";
  };

  installPhase = ''
    runHook preInstall

    # `pnpm prune` doesn't support monorepos, and with pnpm 12 it also tries
    # to verify the lockfile against supply-chain policies over the network.
    # Reinstall production dependencies only instead, as `pnpm prune --help`
    # recommends for monorepos.
    rm -rf node_modules
    pnpm install \
      --config.trust-lockfile=true \
      --frozen-lockfile \
      --ignore-scripts \
      --offline \
      --prod

    # TODO: Consider using prune again when pnpm_12 is updated to >= v12.15.0.
    # See: https://github.com/pnpm/pnpm/issues/16999
    #
    # # Remove development dependencies to shrink closure size
    # CI=true pnpm prune --prod --ignore-scripts

    mkdir -p $out/bin $out/lib
    cp -r * $out/lib

    makeWrapper ${nodejs}/bin/node "$out/bin/cdxgen" --add-flags "$out/lib/bin/cdxgen.js"

    for name in audit convert evinse hbom repl sign tracebom validate verify; do
      makeWrapper ${nodejs}/bin/node "$out/bin/cdxgen-$name" --add-flags "$out/lib/bin/$name.js"
    done

    runHook postInstall
  '';

  preFixup = ''
    # Remove broken development symlinks
    find $out -xtype l -print -delete
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };

    sbom =
      runCommand "${finalAttrs.pname}-${finalAttrs.version}-test-sbom"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          pushd ${finalAttrs.src}/test/repotests/npm-smoke
          cdxgen -t npm -o $out/bom.json .
          grep -q '"bomFormat"' "$out/bom.json"
          popd
        '';
  };

  meta = {
    description = "Creates CycloneDX Software Bill-of-Materials (SBOM) for your projects from source and container images";
    mainProgram = "cdxgen";
    homepage = "https://github.com/cdxgen/cdxgen";
    changelog = "https://github.com/cdxgen/cdxgen/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      quincepie
    ];
    teams = with lib.teams; [ ngi ];
  };
})
