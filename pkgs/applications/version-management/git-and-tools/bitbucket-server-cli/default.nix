{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  name = "bitbucket-server-cli-${version}";

  version = (import ./gemset.nix).atlassian-stash.version;
  inherit ruby;
  gemdir = ./.;

  pname = "atlassian-stash";

  meta = with lib; {
    description = "A command line interface to interact with BitBucket Server (formerly Atlassian Stash)";
    homepage    = https://bitbucket.org/atlassian/bitbucket-server-cli;
    license     = licenses.mit;
    maintainers = with maintainers; [ jgertm ];
    platforms   = platforms.unix;
  };
}
