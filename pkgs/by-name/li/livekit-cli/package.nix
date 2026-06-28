{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  pkg-config,
  portaudio,
}:

buildGoModule (finalAttrs: {
  pname = "livekit-cli";
  version = "2.16.6";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lsvbnc2YGPX2OYmdH6ZW0a6eNF+o3S8Y0eLuYsb4dUs=";
  };

  vendorHash = "sha256-BzEv2wpcXX7at6jJdgy9DtErbIU8ZPL+ollK1rlUWSA=";

  # Use nixpkgs portaudio package + pkg-config rather than relying on a vendored
  # git submodule, similar to the homebrew solution
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ portaudio ];
  tags = [ "portaudio_system" ];

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
