{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "livekit-cli";
  version = "2.13.1";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZxMqZIkJzI/FeuCbBr9H+2bDNmPKjNEW8LFcuaO3Lfs=";
  };

  vendorHash = "sha256-CejPt5+dJEBEuBbliRkaHEXzZlOsddSXQaJ87CJxGyU=";

  subPackages = [ "cmd/lk" ];

  passthru.updateScript = nix-update-script { };
  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    description = "Command line interface to LiveKit";
    homepage = "https://livekit.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mgdelacroix
      faukah
    ];
    mainProgram = "lk";
  };
})
