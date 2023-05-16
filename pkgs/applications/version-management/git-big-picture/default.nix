<<<<<<< HEAD
{ lib, python3Packages, fetchPypi, git, graphviz }:
=======
{ python3Packages, lib, git, graphviz }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "git-big-picture";
  version = "1.1.1";
  format = "wheel";

<<<<<<< HEAD
  src = fetchPypi {
    inherit format version;
    pname = "git_big_picture"; # underscores needed for working download URL
    python = "py3"; # i.e. no Python 2.7
=======
  src = python3Packages.fetchPypi {
    inherit format version;
    pname = "git_big_picture";  # underscores needed for working download URL
    python = "py3";  # i.e. no Python 2.7
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    sha256 = "a20a480057ced1585c4c38497d27a5012f12dd29697313f0bb8fa6ddbb5c17d8";
  };

  postFixup = ''
    wrapProgram $out/bin/git-big-picture \
      --prefix PATH ":" ${ lib.makeBinPath [ git graphviz ]  }
<<<<<<< HEAD
  '';
=======
    '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    description = "Tool for visualization of Git repositories";
    homepage = "https://github.com/git-big-picture/git-big-picture";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.nthorne ];
  };
}
