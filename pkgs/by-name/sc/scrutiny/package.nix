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

      npmDepsHash = "sha256-1lOskHEU/3CmhQkUkQExryK6eMOSWvMI+Y+cX4Dlj98=";

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

      passthru.updateScript = nix-update-script { };
    };
in
buildGoModule (finalAttrs: {
  pname = "scrutiny";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "AnalogJ";
    repo = "scrutiny";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZQHTwJZBOYJ2De0CmyxXc4Fb2Vt+jKg+YpDDZhSt+cg=";
  };

  subPackages = "webapp/backend/cmd/scrutiny";

  vendorHash = "sha256-Em8k2AFoZv4TD4HFkkNIdyPj7IBOFiUIKffkifWfZFY=";

  env.CGO_ENABLED = 0;

  ldflags = [ "-extldflags=-static" ];

  tags = [ "static" ];

  postInstall = ''
    mkdir -p $out/share/scrutiny
    cp -r ${frontend finalAttrs}/* $out/share/scrutiny
  '';

  passthru.tests.scrutiny = nixosTests.scrutiny;
  passthru.updateScript = nix-update-script { };

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
