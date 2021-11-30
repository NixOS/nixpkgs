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
    rev = "a04540b406599803c9e38923c74f2833157faa08";
    sha256 = "07br334zm518l10i4hakgpbzwiq2b3xljj996dgfka6dcpw6kipi";
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
