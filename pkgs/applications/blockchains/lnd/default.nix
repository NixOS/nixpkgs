{ buildGoModule
, fetchFromGitHub
, lib
, tags ? [ "autopilotrpc" "signrpc" "walletrpc" "chainrpc" "invoicesrpc" "watchtowerrpc" "routerrpc" "monitoring" "kvdb_postgres" "kvdb_etcd" ]
}:

buildGoModule rec {
  pname = "lnd";
<<<<<<< HEAD
  version = "0.16.3-beta";
=======
  version = "0.16.2-beta";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-/seSpWnlQmeU4vQtlHMOSedPXP9HJp1GyxcB1LqHayA=";
  };

  vendorHash = "sha256-obrSVMqTwHe7231wa0OuoT6ANBqkQbkHIy93J2f68Zk=";
=======
    sha256 = "sha256-s0m/aS99uB6LZb0+73SQ++mF0Ukg6IYIL+jbEi8ezW0=";
  };

  vendorSha256 = "sha256-7Ydl56Z6aOMBQ1RamFzjD/yp3zgQLkF5WEoOQe1Urv0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/lncli" "cmd/lnd" ];

  preBuild = let
    buildVars = {
      RawTags = lib.concatStringsSep "," tags;
      GoVersion = "$(go version | egrep -o 'go[0-9]+[.][^ ]*')";
    };
    buildVarsFlags = lib.concatStringsSep " " (lib.mapAttrsToList (k: v: "-X github.com/lightningnetwork/lnd/build.${k}=${v}") buildVars);
  in
  lib.optionalString (tags != []) ''
    buildFlagsArray+=("-tags=${lib.concatStringsSep " " tags}")
    buildFlagsArray+=("-ldflags=${buildVarsFlags}")
  '';

  meta = with lib; {
    description = "Lightning Network Daemon";
    homepage = "https://github.com/lightningnetwork/lnd";
    license = licenses.mit;
    maintainers = with maintainers; [ cypherpunk2140 prusnak ];
  };
}
