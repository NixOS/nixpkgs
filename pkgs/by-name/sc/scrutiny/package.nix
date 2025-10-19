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
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "AnalogJ";
    repo = "scrutiny";
    tag = "v${version}";
    hash = "sha256-WoU5rdsIEhZQ+kPoXcestrGXC76rFPvhxa0msXjFsNg=";
  };

  frontend = buildNpmPackage {
    inherit version;
    pname = "${pname}-webapp";
    src = "${src}/webapp/frontend";

    npmDepsHash = "sha256-M8P41LPg7oJ/C9abDuNM5Mn+OO0zK56CKi2BwLxv8oQ=";

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

    passthru.updatescript = nix-update-script { };
  };
in
buildGoModule rec {
  inherit pname src version;

  subPackages = "webapp/backend/cmd/scrutiny";

  vendorHash = "sha256-SiQw6pq0Fyy8Ia39S/Vgp9Mlfog2drtVn43g+GXiQuI=";

  env.CGO_ENABLED = 0;

  ldflags = [ "-extldflags=-static" ];

  tags = [ "static" ];

  postInstall = ''
    mkdir -p $out/share/scrutiny
    cp -r ${frontend}/* $out/share/scrutiny
  '';

  passthru.tests.scrutiny = nixosTests.scrutiny;
  passthru.updatescript = nix-update-script { };

  meta = {
    description = "Hard Drive S.M.A.R.T Monitoring, Historical Trends & Real World Failure Thresholds";
    homepage = "https://github.com/AnalogJ/scrutiny";
    changelog = "https://github.com/AnalogJ/scrutiny/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "scrutiny";
    platforms = lib.platforms.linux;
  };
}
