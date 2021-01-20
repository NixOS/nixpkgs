{ pkgs, nodejs, stdenv, lib, ... }:

let
  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages.n8n.override {
  nativeBuildInputs = with pkgs.nodePackages; [
    node-pre-gyp
  ];
  meta = with lib; {
    description = "Free and open fair-code licensed node based Workflow Automation Tool";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.asl20;
  };
}
