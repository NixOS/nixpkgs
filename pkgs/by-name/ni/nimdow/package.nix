{ lib, buildNimPackage, fetchFromGitHub, nixosTests, versionCheckHook }:

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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.tests = {
    nimdow = nixosTests.nimdow;
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
