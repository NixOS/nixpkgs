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
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "Starosdev";
    repo = "scrutiny";
    tag = "v${version}";
    hash = "sha256-xoXL8yLrYyjpkxLmbFQz/pp2BauJAU82x1FcslHCPoE=";
  };

  frontend = buildNpmPackage {
    inherit version;
    pname = "${pname}-webapp";
    src = "${src}/webapp/frontend";

    npmDepsHash = "sha256-lOEHLXY13qxWWl2cnmbbqbXXKcg7PNMEMdRhE2HGrAM=";

    buildPhase = ''
      runHook preBuild
      mkdir dist
      npm run build:prod --offline -- --output-path=dist
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir $out
      cp -r dist/browser/* $out
      runHook postInstall
    '';

    passthru.updateScript = nix-update-script { };
  };
in
buildGoModule rec {
  inherit pname src version;

  subPackages = "webapp/backend/cmd/scrutiny";

  vendorHash = "sha256-nfL+44lKBmAcScoV0AHotSotQz4Z3kHIpePERuncM6c=";

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
    homepage = "https://github.com/Starosdev/scrutiny";
    changelog = "https://github.com/Starosdev/scrutiny/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samasaur ];
    mainProgram = "scrutiny";
    platforms = lib.platforms.linux;
  };
}
