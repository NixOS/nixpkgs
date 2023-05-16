{ lib, fetchFromGitHub }:
rec {
<<<<<<< HEAD
  version = "9.0.1811";
=======
  version = "9.0.1441";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "vim";
    repo = "vim";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-b/fATWaHcIZIvkmr/UQ4R45ii9N0kWJMb7DerF/JYIA=";
=======
    hash = "sha256-tGWOIXx4gNMg0CB4ytUrj9bQLXw+4pl2lfgGR81+EJk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  enableParallelBuilding = true;
  enableParallelInstalling = false;

  hardeningDisable = [ "fortify" ];

  postPatch =
    # Use man from $PATH; escape sequences are still problematic.
    ''
      substituteInPlace runtime/ftplugin/man.vim \
        --replace "/usr/bin/man " "man "
    '';

  meta = with lib; {
    description = "The most popular clone of the VI editor";
    homepage    = "http://www.vim.org";
    license     = licenses.vim;
    maintainers = with maintainers; [ das_j equirosa ];
    platforms   = platforms.unix;
<<<<<<< HEAD
    mainProgram = "vim";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
