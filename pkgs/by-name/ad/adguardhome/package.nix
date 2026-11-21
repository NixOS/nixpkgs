{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
  nixosTests,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "adguardhome";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = "AdGuardHome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+pn+0OEk9CR3HdMvxtpAUId2ivzZWTHVuDO6gfCGGOw=";
  };

  vendorHash = "sha256-J9MjRREeFe3NI9jmECaZ6rqRIRwDx2PfcgirJOPx084=";

  dashboard = buildNpmPackage {
    inherit (finalAttrs) src version;
    pname = "adguardhome-dashboard";
    postPatch = ''
      cd client_v2
    '';
    npmDepsHash = "sha256-PV5G1DOOk1Q2dJNfBp9uEeRIFHyUBpf8Un9X8AX9Ro8=";
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

  __darwinAllowLocalNetworking = true;
  __structuredAttrs = true;
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin (
    let
      skippedTests = [
        "TestDoQServer"
        "TestWeekly_UnmarshalYAML/bad_time_zone"
        "TestWeekly_UnmarshalJSON/bad_time_zone"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ]
  );

  passthru = {
    updateScript = ./update.sh;
    schema_version = 34;
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
