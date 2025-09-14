{
  lib,
  nix-update-script,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goda";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "loov";
    repo = "goda";
    rev = "v${version}";
    hash = "sha256-byRficALfYADK2lXskAvYeLxwrzOQXACTLlDRrMoHrw=";
  };

  vendorHash = "sha256-AkO3Ag2FiAC46ZXmG3mVhhWpcaw/Z3oik2cyGmoJFpc=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/loov/goda";
    description = "Go Dependency Analysis toolkit";
    maintainers = with lib.maintainers; [ michaeladler ];
    license = lib.licenses.mit;
    mainProgram = "goda";
  };
}
