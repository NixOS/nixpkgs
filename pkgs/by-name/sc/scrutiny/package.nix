{
  buildNpmPackage,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  lib,
  nix-update-script,
}:
let
  pname = "scrutiny";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "AnalogJ";
    repo = "scrutiny";
    tag = "v${version}";
    hash = "sha256-0NgAdgtlsAetXfFqJdYpvzEXL4Ibh4yzAjOaOFoMvrs=";
  };

  frontend = buildNpmPackage {
    inherit version;
    pname = "${pname}-webapp";
    src = "${src}/webapp/frontend";

    npmDepsHash = "sha256-EgIM3iu/dGQhzanWjjBFmLHU3EOy2riScXCDSwAvAZc=";

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
buildGoModule rec {
  inherit pname src version;

  subPackages = "webapp/backend/cmd/scrutiny";

  vendorHash = "sha256-4qjKGjCvB0ggf6Cda7LfMeqbbBbhGcxB2ZfymUhajq8=";

  env.CGO_ENABLED = 0;

  ldflags = [ "-extldflags=-static" ];

  tags = [ "static" ];

  postInstall = ''
    mkdir -p $out/share/scrutiny
    cp -r ${frontend}/* $out/share/scrutiny
  '';

  passthru.tests.scrutiny = nixosTests.scrutiny;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hard Drive S.M.A.R.T Monitoring, Historical Trends & Real World Failure Thresholds";
    homepage = "https://github.com/AnalogJ/scrutiny";
    changelog = "https://github.com/AnalogJ/scrutiny/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      samasaur
      svistoi
    ];
    mainProgram = "scrutiny";
    platforms = lib.platforms.linux;
  };
}
