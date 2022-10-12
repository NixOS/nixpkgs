{ pkgs, nodejs-16_x, stdenv, lib, nixosTests }:

let
  nodePackages = import ./node-composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages.n8n.override {
  nativeBuildInputs = [
    pkgs.nodePackages.node-pre-gyp
  ];

  buildInputs = [
    pkgs.postgresql
  ];

  dontNpmInstall = true;

  passthru = {
    updateScript = ./generate-dependencies.sh;
    tests = nixosTests.n8n;
  };

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
