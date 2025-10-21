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
  version = "0.107.67";
  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = "AdGuardHome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6njbIn4uX+80qA7lHM44PEcyr9J5/UZ4si/e3Xw6pc4=";
  };

  vendorHash = "sha256-M0QqBWeNAlf/BxCJMx+NqvxbIhcBBundI1QakTb9Ojw=";

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
    schema_version = 30;
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
