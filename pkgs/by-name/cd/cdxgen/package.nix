{
  cctools,
  fetchFromGitHub,
  lib,
  makeWrapper,
  nodejs,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  stdenv,

  # tests
  runCommand,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cdxgen";
  version = "13.0.1";

  src = fetchFromGitHub {
    owner = "cdxgen";
    repo = "cdxgen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wnvAeZprSUDCFO5UXyycrF2cZ+a/E70k5V8CM6IJ0NM=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpmConfigHook
    pnpm_11
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin cctools.libtool;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-hVa6Um0WkcsI8MwwkqwFwOqESTMzR2Ox9DSmESzEDfQ=";
  };

  installPhase = ''
    runHook preInstall

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
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      quincepie
    ];
    teams = with lib.teams; [ ngi ];
  };
})
