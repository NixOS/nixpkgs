{ pkgs, nodejs-14_x, stdenv, lib }:

let
  nodePackages = import ./node-composition.nix {
    inherit pkgs;
    nodejs = nodejs-14_x;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages.n8n.override {
  nativeBuildInputs = with pkgs.nodePackages; [
    node-pre-gyp
  ];

  passthru.updateScript = ./generate-dependencies.sh;

  meta = with lib; {
    description = "Free and open fair-code licensed node based Workflow Automation Tool";
    maintainers = with maintainers; [ freezeboy k900 ];
    license = {
      fullName = "Sustainable Use License";
      url = "https://github.com/n8n-io/n8n/blob/master/LICENSE.md";
      free = false;
      # only free to redistribute "for non-commercial purposes"
      redistributable = false;
    };
  };
}
