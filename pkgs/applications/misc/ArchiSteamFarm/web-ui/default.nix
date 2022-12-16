{ lib, pkgs, fetchFromGitHub, nodejs, stdenv, ArchiSteamFarm, ... }:

let
  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = "5f9969bf17e4c6915418655b35fc6b790cd2da0b";
    sha256 = "03y4ahq958rxjnddwnc6h95drdpnvpy16adk434aak4l8hqr24sg";
  };

in
nodePackages.package.override {
  inherit src;

  # upstream isn't tagged, but we are using the latest official commit for that specific asf version (assuming both get updated at the same time)
  version = ArchiSteamFarm.version;

  nativeBuildInputs = [ pkgs.nodePackages.node-gyp-build ];

  postInstall = ''
    patchShebangs node_modules/
    npm run build
    cp -r $out/lib/node_modules/asf-ui/dist $out/lib/dist
    rm -rf $out/lib/node_modules/
  '';

  meta = with lib; {
    description = "The official web interface for ASF";
    license = licenses.apsl20;
    homepage = "https://github.com/JustArchiNET/ASF-ui";
    inherit (ArchiSteamFarm.meta) maintainers platforms;
  };
}
