{ stdenv, fetchFromGitHub, git, which }:

stdenv.mkDerivation rec {
  name = "git-subrepo-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ingydotnet";
    repo = "git-subrepo";
    rev = "${version}";
    sha256 = "05m2dm9gq2nggwnxxdyq2kjj584sn2lxk66pr1qhjxnk81awj9l7";
  };

  buildInputs = [
    git which
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "INSTALL_LIB=$(out)/bin"
    "INSTALL_MAN=$(out)/share/man/man1"
  ];

  patches = [
    # Allow zsh completion to work even though we aren't installing from a git
    # clone.  Also submitted upstream as
    # https://github.com/ingydotnet/git-subrepo/pull/420
    ./zsh-completion.patch
  ];

  postInstall = ''
    ZSH_COMP_DIR="$out/share/zsh/vendor-completions"
    mkdir -p "$ZSH_COMP_DIR"
    cp share/zsh-completion/_git-subrepo "$ZSH_COMP_DIR/"

    BASH_COMP_DIR="$out/share/bash-completion/completions"
    mkdir -p "$BASH_COMP_DIR"
    cp share/completion.bash "$BASH_COMP_DIR/git-subrepo"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/ingydotnet/git-subrepo;
    description = "Git submodule alternative";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.ryantrinkle ];
  };
}
