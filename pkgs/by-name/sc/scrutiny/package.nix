{ buildNpmPackage
, buildGoModule
, fetchFromGitHub
, nixosTests
, lib
}:
let
  pname = "scrutiny";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "AnalogJ";
    repo = "scrutiny";
    rev = "refs/tags/v${version}";
    hash = "sha256-S7GW8z6EWB+5vntKew0+EDVqhun+Ae2//15dSIlfoSs=";
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
  };
in
buildGoModule rec {
  inherit pname src version;

  subPackages = "webapp/backend/cmd/scrutiny";

  vendorHash = "sha256-SiQw6pq0Fyy8Ia39S/Vgp9Mlfog2drtVn43g+GXiQuI=";

  CGO_ENABLED = 0;

  ldflags = [ "-extldflags=-static" ];

  tags = [ "static" ];

  postInstall = ''
    mkdir -p $out/share/scrutiny
    cp -r ${frontend}/* $out/share/scrutiny
  '';

  passthru.tests.scrutiny = nixosTests.scrutiny;

  meta = {
    description = "Hard Drive S.M.A.R.T Monitoring, Historical Trends & Real World Failure Thresholds.";
    homepage = "https://github.com/AnalogJ/scrutiny";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jnsgruk ];
    mainProgram = "scrutiny";
    platforms = lib.platforms.linux;
  };
}
