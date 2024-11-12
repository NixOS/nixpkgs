{ lib, bundlerEnv, ruby, bundlerUpdateScript }:

bundlerEnv rec {
  name = "bitbucket-server-cli-${version}";

  version = (import ./gemset.nix).atlassian-stash.version;
  inherit ruby;
  gemdir = ./.;

  pname = "atlassian-stash";

  passthru.updateScript = bundlerUpdateScript "bitbucket-server-cli";

  meta = with lib; {
    description = "Command line interface to interact with BitBucket Server (formerly Atlassian Stash)";
    homepage    = "https://bitbucket.org/atlassian/bitbucket-server-cli";
    license     = licenses.mit;
    maintainers = with maintainers; [ jgertm nicknovitski ];
    mainProgram = "stash";
    platforms   = platforms.unix;
  };
}
