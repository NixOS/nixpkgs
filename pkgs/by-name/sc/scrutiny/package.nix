{
  buildNpmPackage,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  lib,
  nix-update-script,
}:
let
  frontend =
    finalAttrs:
    buildNpmPackage {
      inherit (finalAttrs) version;
      pname = "${finalAttrs.pname}-webapp";
      src = "${finalAttrs.src}/webapp/frontend";

      npmDepsHash = "sha256-iprdyz9x6Bzn8lymBKBAf3cMe8r5fmW78TNKa488XAg=";

      buildPhase = ''
        runHook preBuild
        mkdir dist
        npm run build:prod --offline -- --output-path=dist
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir $out
        cp -r dist/* $out
        runHook postInstall
      '';
    };
in
buildGoModule (finalAttrs: {
  pname = "scrutiny";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "AnalogJ";
    repo = "scrutiny";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cJpn2FPbv/sEuleU9GUZiYl3mi6r6TuVJb117PJv1lo=";
  };

  subPackages = "webapp/backend/cmd/scrutiny";

  vendorHash = "sha256-d9DHXbvEOpg7Igae25v88DNXOrEI7dRVl+I84R7eve4=";

  env.CGO_ENABLED = 0;

  ldflags = [ "-extldflags=-static" ];

  tags = [ "static" ];

  postInstall = ''
    mkdir -p $out/share/scrutiny
    cp -r ${frontend finalAttrs}/* $out/share/scrutiny
  '';

  passthru = {
    frontend = frontend finalAttrs;
    tests.scrutiny = nixosTests.scrutiny;
    updateScript = nix-update-script { extraArgs = [ "--subpackage=frontend" ]; };
  };

  meta = {
    description = "Hard Drive S.M.A.R.T Monitoring, Historical Trends & Real World Failure Thresholds";
    homepage = "https://github.com/AnalogJ/scrutiny";
    changelog = "https://github.com/AnalogJ/scrutiny/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      samasaur
      svistoi
    ];
    mainProgram = "scrutiny";
    platforms = lib.platforms.linux;
  };
})
