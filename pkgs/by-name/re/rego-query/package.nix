{
  lib,
  stdenv,
  buildGoModule,
  fetchFromSourcehut,
  which,
}:

buildGoModule (finalAttrs: {
  pname = "rego-query";
  version = "0.0.16";

  src = fetchFromSourcehut {
    owner = "~charles";
    repo = "rq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MTUuNIw8HD9LV/Q678M1xH7VzKViwMkPlz/LicLMNWY=";
  };

  vendorHash = "sha256-APmEsnfJ07ENzdIebrfNPSxypzTuRpCNhTvNK9n1Gmk=";

  subPackages = [ "cmd/rq" ];

  nativeCheckInputs = [ which ];

  postCheck = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    substituteInPlace smoketest/smoketest.sh \
      --replace-fail 'RQ="$(pwd)/../build/rq"' "RQ=$GOPATH/bin/rq"
    patchShebangs --build smoketest
    smoketest/smoketest.sh
  '';

  meta = {
    description = "CLI tool for evaluating Rego Queries";
    mainProgram = "rq";
    homepage = "https://sr.ht/~charles/rq";
    changelog = "https://git.sr.ht/~charles/rq/tree/${finalAttrs.src.rev}/item/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      refi64
      push-f
    ];
  };
})
