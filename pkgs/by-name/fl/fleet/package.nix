{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  yarnConfigHook,
  yarnBuildHook,
  nodejs_24,
  fetchYarnDeps,
  buildGoModule,
  go-bindata,
  versionCheckHook,
}:
let
  pname = "fleet";
  version = "4.78.1";
  src = fetchFromGitHub {
    owner = "fleetdm";
    repo = "fleet";
    tag = "fleet-v${version}";
    hash = "sha256-3F9vzY1JAw2DMzUhMl7j9I8RGjVXulQH2JcYCFuAwDY=";
  };

  frontend = stdenvNoCC.mkDerivation {
    pname = "${pname}-frontend";
    inherit version src;

    nativeBuildInputs = [
      yarnConfigHook
      yarnBuildHook
      nodejs_24
    ];

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = src + "/yarn.lock";
      hash = "sha256-cCf0Q6g+VJaTCOZ12/7z8gcDf3+YT2LBTCJb39InJVw=";
    };

    NODE_ENV = "production";
    yarnBuildScript = "webpack";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/assets
      cp -r assets/* $out/assets/

      mkdir -p $out/frontend/templates
      cp frontend/templates/react.tmpl $out/frontend/templates/react.tmpl

      runHook postInstall
    '';
  };
in
buildGoModule (finalAttrs: {
  inherit pname version src;

  vendorHash = "sha256-EwPbZLcqJV5J7ieoQwAJLIn4wwMlwZoTtWaXgvY3pR0=";

  subPackages = [
    "cmd/fleet"
  ];

  ldflags = [
    "-X github.com/fleetdm/fleet/v4/server/version.appName=fleet"
    "-X github.com/fleetdm/fleet/v4/server/version.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ go-bindata ];

  preBuild = ''
    cp -r ${frontend}/assets/* assets
    cp -r ${frontend}/frontend/templates/react.tmpl frontend/templates/react.tmpl

    go-bindata -pkg=bindata -tags full \
      -o=server/bindata/generated.go \
      frontend/templates/ assets/... server/mail/templates
  '';

  tags = [ "full" ];

  doInstallCheck = true;
  versionCheckProgramArg = "version";
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru = {
    inherit frontend;
  };

  meta = {
    homepage = "https://github.com/fleetdm/fleet";
    changelog = "https://github.com/fleetdm/fleet/releases/tag/fleet-v${finalAttrs.version}";
    description = "CLI tool to launch Fleet server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      asauzeau
      lesuisse
      bddvlpr
    ];
    mainProgram = "fleet";
  };
})
