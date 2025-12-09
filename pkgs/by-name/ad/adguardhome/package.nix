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
  version = "0.107.69";
  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = "AdGuardHome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eUMssp4rYmkreYdaSDlYP0bQsZgsrrN9e65UF7NseN8=";
  };

  vendorHash = "sha256-qee3ifDDR1U23VZAu0gj1CPPaDrSQfwfrKte1OUZPlE=";

  dashboard = buildNpmPackage {
    inherit (finalAttrs) src version;
    pname = "adguardhome-dashboard";
    postPatch = ''
      cd client
    '';
    npmDepsHash = "sha256-AYm4ZgTsPJ6aNL7fo9DJqC0yq9i1mJghO7zWWC1X9eA=";
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
    schema_version = 31;
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
