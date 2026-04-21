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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "AnalogJ";
    repo = "scrutiny";
    tag = "v${version}";
    hash = "sha256-N6CYVhdA0BWewGUxyHtkW1ZFDGBYI7QfUo5er7xRcFw=";
  };

  frontend = buildNpmPackage {
    inherit version;
    pname = "${pname}-webapp";
    src = "${src}/webapp/frontend";

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
buildGoModule rec {
  inherit pname src version;

  subPackages = "webapp/backend/cmd/scrutiny";

  vendorHash = "sha256-fyHWy1TwwzFMIFzwilu4osfl/iI+2KqI6Bjr1UYUS68=";

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
