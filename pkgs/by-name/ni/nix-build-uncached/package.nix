{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
}:

buildGoModule rec {
  pname = "nix-build-uncached";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-build-uncached";
    rev = "v${version}";
    sha256 = "sha256-n9Koi01Te77bpYbRX46UThyD2FhCu9OGHd/6xDQLqjQ=";
  };

  vendorHash = null;

  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];

  meta = with lib; {
    description = "CI friendly wrapper around nix-build";
    mainProgram = "nix-build-uncached";
    license = licenses.mit;
    homepage = "https://github.com/Mic92/nix-build-uncached";
    maintainers = [ maintainers.mic92 ];
  };
}
