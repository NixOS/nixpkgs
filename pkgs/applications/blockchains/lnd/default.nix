{ buildGoModule
, fetchFromGitHub
, lib
, tags ? [ "autopilotrpc" "signrpc" "walletrpc" "chainrpc" "invoicesrpc" "watchtowerrpc" "routerrpc" "monitoring" "kvdb_postgres" "kvdb_etcd" ]
}:

buildGoModule rec {
  pname = "lnd";
  version = "0.15.4-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${version}";
    sha256 = "sha256-/PKW2Y6+PlWk88pC4DHFi1ZRqMfQzoO9MVLYZrB2UNc=";
  };

  vendorSha256 = "sha256-bUo0PhtOFhsZfhAXtRJMjfaLrAsOv3ksxsrPOlMNv48=";

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
