{ lib
, stdenv
, fetchFromGitLab
, cmake
, protobuf
 }:

stdenv.mkDerivation rec {
  pname = "goldberg-emu";
  version = "0.2.5";

  src = fetchFromGitLab {
    owner = "mr_goldberg";
    repo = "goldberg_emulator";
    rev = version;
    sha256 = "sha256-goOgMNjtDmIKOAv9sZwnPOY0WqTN90LFJ5iEp3Vkzog=";
  };

  # It attempts to install windows-only libraries which we never build
  patches = [ ./dont-install-unsupported.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ protobuf ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/share/goldberg"
  ];

  preFixup = ''
    mkdir -p $out/{bin,lib}
    chmod +x $out/share/goldberg/tools/find_interfaces.sh

    ln -s $out/share/goldberg/libsteam_api.so $out/lib
    ln -s $out/share/goldberg/lobby_connect/lobby_connect $out/bin
    ln -s $out/share/goldberg/tools/generate_interfaces_file $out/bin
    ln -s $out/share/goldberg/tools/find_interfaces.sh $out/bin/find_interfaces
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://gitlab.com/Mr_Goldberg/goldberg_emulator";
    changelog = "https://gitlab.com/Mr_Goldberg/goldberg_emulator/-/releases";
    description = "Program that emulates steam online features";
    longDescription = ''
      Steam emulator that emulates steam online features. Lets you play games that
      use the steam multiplayer apis on a LAN without steam or an internet connection.
    '';
    mainProgram = "lobby_connect";
    license = licenses.lgpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.ivar ];
  };
}
