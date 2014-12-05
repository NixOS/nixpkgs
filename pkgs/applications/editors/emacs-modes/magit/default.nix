{ stdenv, fetchFromGitHub, emacs, texinfo, gitModes, git }:

stdenv.mkDerivation rec {
  name = "magit-90141025";

  src = fetchFromGitHub {
    owner = "magit";
    repo = "magit";
    rev = "50c08522c8a3c67e0f3b821fe4df61e8bd456ff9";
    sha256 = "0mzyx72pidzvla1x2qszn3c60n2j0n8i5k875c4difvd1n4p0vsk";
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
