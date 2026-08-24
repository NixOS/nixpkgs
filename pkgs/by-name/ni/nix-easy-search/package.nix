{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nix-easy-search";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Sh0rtRound-wq";
    repo = "NixEasySearch";
    rev = "v${version}";
    hash = "sha256-LvWXZlTUVVJpcjKdVDojyuw246RgOm9dDh9LgWAT49I=";
  };

  vendorHash = null;

  postInstall = ''
    mv $out/bin/nix-easy-search $out/bin/nes
  '';

  meta = {
    description = "Fast NixOS package search CLI with clean output";
    homepage = "https://github.com/Sh0rtRound-wq/NixEasySearch";
    license = lib.licenses.mit;
    mainProgram = "nes";
    maintainers = [ ];
  };
}
