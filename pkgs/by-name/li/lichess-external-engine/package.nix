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
    rev = "a6ef15a8e395eb609535857aabf18837ea7696cf";
    hash = "sha256-kelpSM7pfeIOXYOug/YkAgULYMyeDhm1fJX5v1n+vKE=";
  };

  dependencies = with python3Packages; [
    requests
  ];

  installPhase = ''
    runHook preInstall
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
