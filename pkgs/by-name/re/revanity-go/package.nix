{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libsodium,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "revanity-go";
  version = "0-unstable-2026-03-30";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ratspeak";
    repo = "revanity-go";
    rev = "0689c73bdc95fe14957f67075891cc6653f3568c";
    hash = "sha256-utf9YcVCdWj78oDGxRSvTXRRXnUPLMypk77yBdOI24c=";
  };

  vendorHash = null;

  buildInputs = [
    libsodium
  ];

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go implementation of Revanity, a Reticulum/LXMF vanity address generator";
    homepage = "https://github.com/ratspeak/revanity-go";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "revanity-go";
  };
})
