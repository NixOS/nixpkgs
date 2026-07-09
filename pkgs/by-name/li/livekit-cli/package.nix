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
  version = "2.16.7";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-flb0gX2mt4dAtB6f9G2i/bkelMc0bKuDOrgNw02icrw=";
  };

  vendorHash = "sha256-0Fdj4j0PoW2MubnxOfnV9qUg0bv1g9aioVmNxikE9Oo=";

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
