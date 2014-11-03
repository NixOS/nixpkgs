{ stdenv, fetchFromGitHub, emacs, texinfo, gitModes, git }:

let
  version = "90141016";
in
stdenv.mkDerivation rec {
  name = "magit-${version}";

  src = fetchFromGitHub {
    owner = "magit";
    repo = "magit";
    rev = version;
    sha256 = "11d3gzj0hlb7wqsjzjb0vf9i0ik4xzwdyayjy4hfgx0gjmymkfx3";
  };

  buildInputs = [ emacs texinfo git ];
  propagatedUserEnvPkgs = [ gitModes ];

  configurePhase = ''
    makeFlagsArray=(
      PREFIX="$out"
      EFLAGS="-L ${gitModes}/share/emacs/site-lisp"
      lispdir="$out/share/emacs/site-lisp"
    )
  '';

  doCheck = true;
  checkTarget = "test";

  postInstall = ''
    mkdir -p $out/bin
    mv "bin/"* $out/bin/
  '';

  meta = {
    homepage = "https://github.com/magit/magit";
    description = "Magit, an Emacs interface to Git";
    license = stdenv.lib.licenses.gpl3Plus;

    longDescription = ''
      With Magit, you can inspect and modify your Git repositories with
      Emacs. You can review and commit the changes you have made to the
      tracked files, for example, and you can browse the history of past
      changes. There is support for cherry picking, reverting, merging,
      rebasing, and other common Git operations.

      Magit is not a complete interface to Git; it just aims to make the
      most common Git operations convenient. Thus, Magit will likely not
      save you from learning Git itself.
    '';

    maintainers = with stdenv.lib.maintainers; [ simons ];
  };
}
