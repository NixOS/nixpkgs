{ buildGoModule
, fetchFromGitHub
, lib
, tags ? [ "autopilotrpc" "signrpc" "walletrpc" "chainrpc" "invoicesrpc" "watchtowerrpc" "routerrpc" "monitoring" ]
}:

buildGoModule rec {
  pname = "lnd";
  version = "0.13.4-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${version}";
    sha256 = "1ykvhbl5i0kqlh0fpzpjass55clys8bpa28brg7d9fs72zv2ks6x";
  };

  vendorSha256 = "13cjb188bzgd3m3p73szxffkab6l7n6wmbvqvicvi9k3mixn5qql";

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
