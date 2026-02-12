{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "lichess-external-engine";
  version = "1.0.0-unstable-2024-05-10";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "lichess-org";
    repo = "external-engine";
    rev = finalAttrs.version;
    sha256 = "18dwzrcvzycmgjsij3lyrih0n1824kv87bl3bl7f4zg9rr46ksci";
  };

  dependencies = with python3Packages; [
    requests
  ];

  doBuild = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 example-provider.py $out/bin/lichess-external-engine

    runHook postInstall
  '';

  # Basic smoke test: --help should succeed.
  installCheckPhase = ''
    $out/bin/lichess-external-engine --help
  '';

  meta = {
    description = "Using engines running outside of the browser for analysis on lichess";
    homepage = "https://github.com/lichess-org/external-engine";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ malix ];
    mainProgram = "lichess-external-engine";
  };
})
