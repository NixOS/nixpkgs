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
  };
}
