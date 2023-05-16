{ stdenv, lib, fetchFromGitHub, jq, nix, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "terranix";
<<<<<<< HEAD
  version = "2.6.0";
=======
  version = "2.5.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mrVanDalo";
    repo = "terranix";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-pNuJxmVMGbBHw7pa+Bx0HY0orXIXoyyAXOKuQ1zpfus=";
=======
    sha256 = "sha256-5s9YFvbYMp8x0uoXM/jOCPPdjau6+4zeK/rGRkXBdx0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,core,modules,lib}
    mv bin core modules lib share $out/

    wrapProgram $out/bin/terranix-doc-json \
      --prefix PATH : ${lib.makeBinPath [ jq nix ]}
  '';

  meta = with lib; {
    description = "A NixOS like terraform-json generator";
    homepage = "https://terranix.org";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mrVanDalo ];
  };
}
