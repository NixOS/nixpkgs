{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "gossa";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.2.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pldubouilh";
    repo = "gossa";
    rev = "v${version}";
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = "sha256-vonhVxXbYI/5Gl9ZwI8+a3YXSjoqLVic1twykiy+e34=";
=======
    hash = "sha256-eMO9aoI+otGQcvBUJtxciQ7yhUidYizLrDjMVchH3qA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  # Tests require a socket connection to be created.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/pldubouilh/gossa";
    description = "A fast and simple multimedia fileserver";
    license = licenses.mit;
    maintainers = with maintainers; [ dsymbol ];
  };
}
