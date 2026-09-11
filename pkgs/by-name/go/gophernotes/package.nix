{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gophernotes";
  # The last release predates several interpreter fixes on master, and upstream has not
  # tagged since.
  version = "0.7.5-unstable-2023-11-03";

  src = fetchFromGitHub {
    owner = "gopherdata";
    repo = "gophernotes";
    rev = "55142043d19696ba037e3e93f9ec6c7f8436e82d";
    sha256 = "sha256-+crqbsZce2xVbXgb6pyXzpP/5eACkWG2T76TUsL1hKA=";
  };

  patches = [
    # The vendored golang.org/x/tools v0.14.0 uses unsafe struct-layout hacks in
    # internal/tokeninternal that are incompatible with Go 1.26+. That package
    # was removed entirely in newer x/tools versions.
    #
    # This patch bumps to golang.org/x/tools v0.45.0 and update all transitive
    # dependencies accordingly. Set godebug gotypesalias=0 because gomacro does
    # not support *types.Alias. soon as it starts.
    #
    # See https://github.com/gopherdata/gophernotes/pull/268
    ./bump-gomacro-and-x-tools-for-generics.patch
  ];

  vendorHash = "sha256-bGaXnd0E6dRNiwvGIn7Ptddrt7dRzPfkPThgHPuL2Vo=";

  meta = {
    description = "Go kernel for Jupyter notebooks";
    homepage = "https://github.com/gopherdata/gophernotes";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.costrouc ];
    mainProgram = "gophernotes";
  };
})
