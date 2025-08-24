{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
  nixosTests,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "adguardhome";
  version = "0.107.64";
  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = "AdGuardHome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UmgWRei3qVkPLtusnXDGeaobxMy1a3Nlb1kBqkcmpxA=";
  };

  vendorHash = "sha256-EKQGbDLaEZGthdBr+Fj5pZ2TBCQ1Df+L9uuI0y/k7XU=";

  dashboard = buildNpmPackage {
    inherit (finalAttrs) src;
    name = "dashboard";
    postPatch = ''
      cd client
    '';
    npmDepsHash = "sha256-s7TJvGyk05HkAOgjYmozvIQ3l2zYUhWrGRJrWdp9ZJQ=";
    npmBuildScript = "build-prod";
    postBuild = ''
      mkdir -p $out/build/
      cp -r ../build/static/ $out/build/
    '';
  };

  preBuild = ''
    cp -r ${finalAttrs.dashboard}/build/static build
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/AdguardTeam/AdGuardHome/internal/version.version=${finalAttrs.version}"
  ];

  passthru = {
    updateScript = ./update.sh;
    schema_version = 29;
    tests.adguardhome = nixosTests.adguardhome;
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://github.com/AdguardTeam/AdGuardHome";
    description = "Network-wide ads & trackers blocking DNS server";
    maintainers = with lib.maintainers; [
      numkem
      iagoq
      rhoriguchi
      baksa
    ];
    license = lib.licenses.gpl3Only;
    mainProgram = "AdGuardHome";
  };
})
