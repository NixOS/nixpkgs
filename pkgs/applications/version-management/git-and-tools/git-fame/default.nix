{ lib, bundlerEnv, ruby, fetchFromGitHub }:

bundlerEnv rec {
  name = "git-fame-${version}";

  version = "2.5.2";
  inherit ruby;
  gemdir = ./.;

  meta = with lib; {
    description = "A command-line tool that helps you summarize and pretty-print collaborators based on contributions";
    homepage    = http://oleander.io/git-fame-rb;
    license     = licenses.mit;
    maintainers = with maintainers; [ expipiplus1 ];
    platforms   = platforms.unix;
  };
}
