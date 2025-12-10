{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  nixosTests,
  testers,
}:

buildNimPackage (finalAttrs: {
  pname = "nimdow";

  version = "0.7.41";

  src = fetchFromGitHub {
    owner = "avahe-kellenberger";
    repo = "nimdow";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oosoiJVlP3XyUeardoyRFladAIKdH3PQvWcNo5XnnOI=";
  };

  lockFile = ./lock.json;

  nimFlags = [
    "--deepcopy:on"
  ];

  postInstall = ''
    install -D config.default.toml $out/share/nimdow/config.default.toml
    install -D nimdow.desktop $out/share/applications/nimdow.desktop
  '';

  postPatch = ''
    substituteInPlace src/nimdowpkg/config/configloader.nim --replace "/usr/share/nimdow" "$out/share/nimdow"
  '';

  passthru.tests = {
    nimdow = nixosTests.nimdow;
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "v${finalAttrs.version}";
    };
  };

  meta =

    finalAttrs.src.meta // {
      description = "Nim based tiling window manager";
      platforms = lib.platforms.linux;
      license = [ lib.licenses.gpl2 ];
      maintainers = [ lib.maintainers.marcusramberg ];
      mainProgram = "nimdow";
    };
})
