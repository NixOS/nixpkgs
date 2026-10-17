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
  version = "13.2.0";

  src = fetchFromGitHub {
    owner = "cdxgen";
    repo = "cdxgen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mOCLKCpxSBqIk3VN5IBIW3SxZWYT2mD8nF197D1VELc=";
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
    fetcherVersion = 4;
    hash = "sha256-xgxO0AgtAKyVIpqaEDtaYK0Tzx+JD+rZvTXLcLyg94I=";
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
    changelog = "https://github.com/cdxgen/cdxgen/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      quincepie
    ];
    teams = with lib.teams; [ ngi ];
  };
})
