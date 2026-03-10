{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "autotitle";
  version = "1.13.0";
  meta = with lib; {
    description = "A CLI tool and Go library for automatically renaming media files";
    homepage = "https://github.com/mydehq/autotitle";
    license = licenses.gpl3;
    mainProgram = "autotitle";
    maintainers = with maintainers; [ ]; # Add your Nixpkgs username here
  };

  src = fetchFromGitHub {
    owner = "mydehq";
    repo = "autotitle";
    rev = "v${version}";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # TODO: replace with actual hash from nix build
  };

  vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # TODO: replace with actual vendorHash from nix build

}
