{
  lib,
  fetchFromGitHub,
  buildNimPackage,
}:

buildNimPackage (finalAttrs: {
  pname = "nph";
  version = "0.6.2";

  postPatch = ''
    substituteInPlace src/nph.nim \
      --replace-fail 'git describe --long --dirty --always --tags' "echo ${finalAttrs.version}"
  '';

  src = fetchFromGitHub {
    owner = "arnetheduck";
    repo = "nph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rO6nEdW36CoQF30VP+zR+Osw2AuBmkXC+ugPrhDvH4o=";
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
