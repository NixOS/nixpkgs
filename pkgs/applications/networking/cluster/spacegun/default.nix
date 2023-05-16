{ pkgs, fetchFromGitHub, nodejs, stdenv, lib, ... }:

let
  src = fetchFromGitHub {
    owner = "dvallin";
    repo = "spacegun";
    rev = "v0.3.3";
    sha256 = "0cd9yzms44dj9ix8lrhbkby5zsyb8wambs24j6c3ibr67sggr6sq";
  };

  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages.package.override {
  inherit src;
  nativeBuildInputs = [ pkgs.makeWrapper pkgs.nodePackages.node-gyp-build ];

  postInstall = ''
    # Patch shebangs in node_modules, otherwise the webpack build fails with interpreter problems
    patchShebangs --build "$out/lib/node_modules/spacegun/node_modules/"
    # compile Typescript sources
    npm run build
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Version controlled multi-cluster deployment manager for kubernetes";
    maintainers = with maintainers; [ ];
    license = licenses.mit;
  };
}
