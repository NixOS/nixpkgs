{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "ondir";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "alecthomas";
    repo = "ondir";
    rev = "cb2f9f8b21e336165fc0a310d677fda75c8e8513";
    hash = "sha256-XTZKFIzJ3xL8ae3zG8nsMhGWvpvRUAQ2b6q/Q1QvGd0=";
  };

  installPhase = ''
    runHook preInstall

    make DESTDIR="$out" PREFIX= install
    cp scripts.* $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Small program to automate tasks specific to certain directories";
    longDescription = ''
      It works by executing scripts in directories when you enter and leave them.
      This is done by overriding the shell builtins cd, pushd, and popd,
       which is a manual action.
      The user is required to add a snippet to their shell initialisation file like .bashrc or .profile.

      Which commands are executed on directory entry and leave is done
       in predefined locations with a .ondirrc file.

      See man ondir for more information
    '';
    homepage = "https://github.com/alecthomas/ondir/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.michaelCTS ];
    mainProgram = "ondir";
  };
}
