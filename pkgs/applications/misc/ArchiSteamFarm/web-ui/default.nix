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
    rev = "5c7d99928e2d390bc1cd5fa74b2f422aa760d78e";
    sha256 = "04wcmqav2q7dchvjyy0k6g8cv5ff1sw2a238sz38670cnwx569r2";
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
      platforms = ArchiSteamFarm.meta.platforms;
      maintainers = with maintainers; [ lom ];
    };
  }
