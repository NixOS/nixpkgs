{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "livekit-cli";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qGxRNsVnrDl8N0hAh8WjumDvaL7Zs90HaRmXORvUWZs=";
  };

  vendorHash = "sha256-6posDd3z2seRvGuWLsmPD5wOz4RVF4ulvmfTqWN29hE=";

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
      carschandler
    ];
    mainProgram = "lk";
  };
})
