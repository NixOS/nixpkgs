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
    rev = "156992e88d5c695375e9f69c29f2c68bec24d2b1";
    sha256 = "0zqiaj0957rr4kzw8q8zkxvd88nqw5ssym81dsd3pa0ypr4vqb4w";
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
      ln -s $out/lib/node_modules/asf-ui/dist $out/lib/dist
    '';

    meta = with lib; {
      description = "The official web interface for ASF";
      license = licenses.apsl20;
      homepage = "https://github.com/JustArchiNET/ASF-ui";
      platforms = ArchiSteamFarm.meta.platforms;
      maintainers = with maintainers; [ lom ];
    };
  }
