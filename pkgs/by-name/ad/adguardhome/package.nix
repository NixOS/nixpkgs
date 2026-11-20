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
  version = "0.107.80";
  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = "AdGuardHome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B+Li3aeijXFcc+AAXkafinldEluHu1oeUdk919eGkxQ=";
  };

  vendorHash = "sha256-xQUbRYS1z9WI8x0Uw/QNrITw8Itof6KxRdtnC0DJVkg=";

  dashboard = buildNpmPackage {
    inherit (finalAttrs) src version;
    pname = "adguardhome-dashboard";
    postPatch = ''
      cd client
    '';
    npmDepsHash = "sha256-Yyv8dTKhZ9IlIW/x/57cl/+cpvjjycaFLSyOR0IiIPk=";
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
