{
  stdenv,
  lib,
  fetchgit,
  zig_0_15,
  jq,
  callPackage,
  testers,
  runCommand,
  ...
}:
let
  zig = zig_0_15;

in
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "makko";
  version = "3.0.0";
  src = fetchgit {
    url = "https://forge.starlightnet.work/Team/Makko.git";
    tag = finalAttrs.version;
    hash = "sha256-glXOWTQrTlHO6yaWM1mExkZL0nLrkKyqeFiTAsK+PQk=";
  };

  nativeBuildInputs = [ zig ];
  zigBuildFlags = [
    "-Doptimize=ReleaseSmall"
    "--system"
    (callPackage ./deps.nix { })
  ];

  passthru = {
    buildMakkoSite = lib.extendMkDerivation {
      constructDrv = stdenv.mkDerivation;
      extendDrvArgs = finalAttrs': prevAttrs': {
        name = "${finalAttrs'.src.name}-rendered";
        nativeBuildInputs = [
          finalAttrs.finalPackage
          jq
        ];
        buildPhase = ''
          runHook preBuild

          makko .

          runHook postBuild
        '';
        installPhase = ''
          runHook preInstall

          cp -r $(jq -r '.paths.output' makko.json)/ $out

          runHook postInstall
        '';
      };
    };
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        version = "Starlight Makko v${finalAttrs.version}";
      };
      siteBuilder = stdenv.mkDerivation {
        name = "makko-example-test";
        src = finalAttrs.finalPackage.buildMakkoSite {
          # generates example makko project
          src = runCommand "makko-test" { nativeBuildInputs = [ finalAttrs.finalPackage ]; } ''
            mkdir $out
            makko $out || true
          '';
        };
        buildPhase = ''
          [ -e feed.atom && -e feed.json && -e feed.rss && -e index.html]

          touch $out
        '';
      };
    };
  };

  meta = {
    description = "A simple, lightweight, and portable Static Site Generator written in Zig.";
    homepage = "https://makko.starlightnet.work/";
    changelog = "https://forge.starlightnet.work/Team/Makko/releases";
    license = lib.licenses.zlib;
    mainProgram = "makko";
    maintainers = [ lib.maintainers.kruemmelspalter ];
  };
})
