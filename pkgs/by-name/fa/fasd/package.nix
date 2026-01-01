{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "fasd";
  version = "unstable-2016-08-11";

  src = fetchFromGitHub {
    owner = "clvv";
    repo = "fasd";
    rev = "90b531a5daaa545c74c7d98974b54cbdb92659fc";
    sha256 = "0i22qmhq3indpvwbxz7c472rdyp8grag55x7iyjz8gmyn8gxjc11";
  };

  installPhase = ''
    PREFIX=$out make install
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/clvv/fasd";
    description = "Quick command-line access to files and directories for POSIX shells";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    homepage = "https://github.com/clvv/fasd";
    description = "Quick command-line access to files and directories for POSIX shells";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    longDescription = ''
      Fasd is a command-line productivity booster.
      Fasd offers quick access to files and directories for POSIX shells. It is
      inspired by tools like autojump, z and v. Fasd keeps track of files and
      directories you have accessed, so that you can quickly reference them in the
      command line.
    '';

<<<<<<< HEAD
    platforms = lib.platforms.all;
=======
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "fasd";
  };
}
