{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "nix-build-uncached";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-build-uncached";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-n9Koi01Te77bpYbRX46UThyD2FhCu9OGHd/6xDQLqjQ=";
  };

  vendorHash = null;

  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];

  meta = {
    description = "CI friendly wrapper around nix-build";
    mainProgram = "nix-build-uncached";
    license = lib.licenses.mit;
    homepage = "https://github.com/Mic92/nix-build-uncached";
    maintainers = [ lib.maintainers.mic92 ];
  };
})
