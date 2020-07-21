{ buildGoModule, fetchFromGitHub, lib
, tags ? [ "autopilotrpc" "signrpc" "walletrpc" "chainrpc" "invoicesrpc" "watchtowerrpc" ]
}:

buildGoModule rec {
  pname = "lnd";
  version = "0.10.3-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${version}";
    sha256 = "129vi8z2sk4hagk7axa675nba6sbj9km88zlq8a1g8di7v2k9z6a";
  };

  vendorSha256 = "0a4bk2qry0isnrvl0adwikqn6imxwzlaq5j3nglb5rmwwq2cdz0r";

  subPackages = ["cmd/lncli" "cmd/lnd"];

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
    license = lib.licenses.mit;
    maintainers = with maintainers; [ cypherpunk2140 ];
  };
}
