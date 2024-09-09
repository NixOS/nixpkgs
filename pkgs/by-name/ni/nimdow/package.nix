{ lib, buildNimPackage, fetchFromGitHub, nixosTests, testers }:

buildNimPackage (finalAttrs: {
  pname = "nimdow";

  version = "0.7.38";

  src = fetchFromGitHub {
    owner = "avahe-kellenberger";
    repo = "nimdow";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GPu3Z63rFBgCCV7bdBg9cJh5thv2xrv/nSMa5Q/zp48=";
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

  meta = with lib;
    finalAttrs.src.meta // {
      description = "Nim based tiling window manager";
      platforms = platforms.linux;
      license = [ licenses.gpl2 ];
      maintainers = [ maintainers.marcusramberg ];
      mainProgram = "nimdow";
    };
})
