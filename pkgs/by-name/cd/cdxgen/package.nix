{
  cctools,
  fetchFromGitHub,
  lib,
  makeWrapper,
  node-gyp,
  nodejs,
  pnpm_9,
  python3,
  stdenv,
  xcbuild,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdxgen";
  version = "11.0.3";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cdxgen";
    rev = "v${finalAttrs.version}";
    hash = "sha256-H83HEiBdXBIhSR18EtYcQey6aXy8URSjpeNVEs3UBm8=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    node-gyp # required for sqlite3 bindings
    pnpm_9.configHook
    python3 # required for sqlite3 bindings
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin [
    xcbuild
    cctools.libtool
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-7NrDYd4H0cPQs8w4lWlB0BhqcYZVo6/9zf0ujPjBzsE=";
  };

  buildPhase = ''
    runHook preBuild

    pushd node_modules/sqlite3
    node-gyp rebuild
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib
    cp -r * $out/lib
    makeWrapper ${nodejs}/bin/node "$out/bin/cdxgen" --add-flags "$out/lib/bin/cdxgen.js"
    makeWrapper ${nodejs}/bin/node "$out/bin/cdxgen-evinse" --add-flags "$out/lib/bin/evinse.js"
    makeWrapper ${nodejs}/bin/node "$out/bin/cdxgen-repl" --add-flags "$out/lib/bin/repl.js"
    makeWrapper ${nodejs}/bin/node "$out/bin/cdxgen-verify" --add-flags "$out/lib/bin/verify.js"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Creates CycloneDX Software Bill-of-Materials (SBOM) for your projects from source and container images";
    mainProgram = "cdxgen";
    homepage = "https://github.com/CycloneDX/cdxgen";
    license = licenses.asl20;
    maintainers = with maintainers; [
      dit7ya
      quincepie
    ];
  };
})
