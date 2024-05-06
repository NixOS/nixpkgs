{
  lib,
  fetchFromGitHub,
  buildNimPackage,
  nim-2_0,
}:
let
  buildNimPackage' = buildNimPackage.override {
    # Do not build with Nim-2.2.x.
    nim2 = nim-2_0;
  };
in
buildNimPackage' (finalAttrs: {
  pname = "nph";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "arnetheduck";
    repo = "nph";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9t5VeGsxyytGdu7+Uv/J+x6bmeB5+eQapbyp30iPxqs=";
  };

  lockFile = ./lock.json;

  checkPhase = ''
    runHook preCheck

    $out/bin/nph tests/before
    diff tests/before tests/after -x "*.yaml"

    runHook postCheck
  '';

  meta = {
    description = "Opinionated code formatter for Nim";
    homepage = "https://github.com/arnetheduck/nph";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "nph";
  };
})
