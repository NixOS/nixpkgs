{ buildGoModule, fetchFromGitHub, lib, tags ? [
  "autopilotrpc"
  "signrpc"
  "walletrpc"
  "chainrpc"
  "invoicesrpc"
  "watchtowerrpc"
  "routerrpc"
  "monitoring"
  "kvdb_postgres"
  "kvdb_etcd"
] }:

buildGoModule rec {
  pname = "lnd";
  version = "0.14.1-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${version}";
    sha256 = "0arm36682y4csdv9abqs0l8rgxkiqkamrps7q8wpyyg4n78yiij3";
  };

  vendorSha256 = "13zhs0gb7chi0zz5rabmw3sd5fcpxc4s553crfcg7lrnbn5hcwzv";

  subPackages = [ "cmd/lncli" "cmd/lnd" ];

  preBuild = let
    buildVars = {
      RawTags = lib.concatStringsSep "," tags;
      GoVersion = "$(go version | egrep -o 'go[0-9]+[.][^ ]*')";
    };
    buildVarsFlags = lib.concatStringsSep " " (lib.mapAttrsToList
      (k: v: "-X github.com/lightningnetwork/lnd/build.${k}=${v}") buildVars);
  in lib.optionalString (tags != [ ]) ''
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
