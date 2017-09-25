{ stdenv, bundlerEnv, ruby, fetchFromGitHub, makeWrapper, bundler }:

bundlerEnv rec {
  inherit ruby;

  pname = "git_fame";

  gemdir = ./.;

  meta = with stdenv.lib; {
    description = ''
      A command-line tool that helps you summarize and pretty-print collaborators based on contributions
      '';
    homepage    = http://oleander.io/git-fame-rb;
    license     = licenses.mit;
    maintainers = with maintainers; [ expipiplus1 ];
    platforms   = platforms.unix;
  };
}
