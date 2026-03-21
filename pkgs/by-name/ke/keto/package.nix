{
  fetchFromGitHub,
  buildGoModule,
  lib,
  versionCheckHook,
}:
let
  pname = "keto";
  version = "26.2.0";
  commit = "e4393662cd2e744deeb79de77669e07b6ccf51f3";
in
buildGoModule rec {
  inherit pname version commit;

  src = fetchFromGitHub {
    owner = "ory";
    repo = "keto";
    tag = "v${version}";
    hash = "sha256-wRtz4RvJ7LxVnSLmXVZFGa9QXjcPnDNJxHKosbyTed0=";
  };

  vendorHash = "sha256-B27aC4yXS36eOoq53+RWp0vq1Oqw2aR+gOjv0m+b/I4=";

  tags = [
    "sqlite"
    "json1"
    "hsm"
  ];

  subPackages = [ "." ];

  # Pass versioning information via ldflags
  ldflags = [
    "-s"
    "-w"
    "-X github.com/ory/keto/internal/driver/config.Version=${src.tag}"
    "-X github.com/ory/keto/internal/driver/config.Commit=${commit}"
  ];

  # tests use dynamic port assignment via port `0`
  __darwinAllowLocalNetworking = true;

  preCheck = ''
    export version='${src.tag}'
  '';

  checkPhase = ''
    runHook preCheck
    # https://github.com/ory/keto/blob/be24ba30ae7e5614fa677e3bcfc1dd6c109251f0/DEVELOP.md?plain=1#L70
    go test -short -tags sqlite ./...
    runHook postCheck
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "version" ];

  meta = {
    description = "ORY Keto, the open source access control server";
    homepage = "https://www.ory.sh/keto/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mrmebelman
      debtquity
    ];
    mainProgram = "keto";
  };
}
