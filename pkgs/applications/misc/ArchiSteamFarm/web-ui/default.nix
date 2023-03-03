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
    rev = "22692a1f115e8ca86f83fa17be55d9b20985570f";
    sha256 = "0k0msk1r7ih092cwjngy1824bxkbjwz0d5p3k2r2l67r2p9b3lab";
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
