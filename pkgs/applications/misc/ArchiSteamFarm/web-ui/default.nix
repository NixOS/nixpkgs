{ lib, pkgs, fetchFromGitHub, nodejs, nodePackages, stdenv, ArchiSteamFarm }:

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
    rev = "bc84d62e4f60f24cca6e9f8e820c30c750bcb0de";
    sha256 = "10z3jv551f41f2k9p6y0yhrqk6jr8pmpkrd479s1zfj40ywh48bc";
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
