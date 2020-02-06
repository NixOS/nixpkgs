{ stdenv, fetchFromGitHub, git, makeWrapper, which }:

stdenv.mkDerivation rec {
  pname = "git-subrepo";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "ingydotnet";
    repo = "git-subrepo";
    rev = version;
    sha256 = "0n10qnc8kyms6cv65k1n5xa9nnwpwbjn9h2cq47llxplawzqgrvp";
  };

  nativeBuildInputs = [
    makeWrapper
    which
  ];

  buildInputs = [
    git
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "INSTALL_LIB=${placeholder "out"}/bin"
    "INSTALL_MAN=${placeholder "out"}/share/man/man1"
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

  postFixup = ''
    wrapProgram $out/bin/git-subrepo \
      --prefix PATH : "${git}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/ingydotnet/git-subrepo;
    description = "Git submodule alternative";
    license = licenses.mit;
    platforms = platforms.unix ++ platforms.darwin;
    maintainers = [ maintainers.ryantrinkle ];
  };
}
