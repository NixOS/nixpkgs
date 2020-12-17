{ stdenv, fetchFromGitHub, rustPlatform, installShellFiles, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-absorb";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner  = "tummychow";
    repo   = pname;
    rev    = "refs/tags/${version}";
    sha256 = "04v10bn24acify34vh5ayymsr1flcyb05f3az9k1s2m6nlxy5gb9";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  cargoSha256 = "0h0vlz4qd8i9bf1mgjr618zbdwfp6bmy7ql9a1xzjmfdpkl3cgk9";

  postInstall = ''
    installManPage Documentation/git-absorb.1
    for shell in bash zsh fish; do
      $out/bin/git-absorb --gen-completions $shell > git-absorb.$shell
      installShellCompletion git-absorb.$shell
    done
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/tummychow/git-absorb";
    description = "git commit --fixup, but automatic";
    license = [ licenses.bsd3 ];
    maintainers = [ maintainers.marsam ];
  };
}
