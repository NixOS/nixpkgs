<<<<<<< HEAD
{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "cz-cli";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "commitizen";
    repo = "cz-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-4kyGxidE8dzkHL0oPv/XxDxQ3qlEE6TKSgj+1g9uvJM=";
  };

  npmDepsHash = "sha256-zQ0T/1khnn+CXm/3yc9nANL0ROEEE03U5fV57btEmPg=";

  meta = with lib; {
    description = "The commitizen command line utility";
    homepage = "https://commitizen.github.io/cz-cli";
    changelog = "https://github.com/commitizen/cz-cli/releases/tag/v${version}";
    maintainers = with maintainers; [ freezeboy natsukium ];
    license = licenses.mit;
=======
{ pkgs, nodejs, stdenv, lib, ... }:

let
  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages.commitizen.override {
  name = "cz-cli";
  meta = with lib; {
    description = "The commitizen command line utility";
    homepage = "https://commitizen.github.io/cz-cli";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
