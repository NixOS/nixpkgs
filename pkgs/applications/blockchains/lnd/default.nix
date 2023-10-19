{ buildGoModule
, fetchFromGitHub
, lib
, tags ? [ "autopilotrpc" "signrpc" "walletrpc" "chainrpc" "invoicesrpc" "watchtowerrpc" "routerrpc" "monitoring" "kvdb_postgres" "kvdb_etcd" ]
}:

buildGoModule rec {
  pname = "lnd";
  version = "0.17.0-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${version}";
    hash = "sha256-HndO7vp/sia352hs23xAgrpyJ/CfbRxYAAhLZ4q94Pc=";
  };

  vendorHash = "sha256-4n81AZLKCTEV4+p4kRhZbzYsdRGIztzh6EKPin8W1Z0=";

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
