{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, bash
}:

stdenv.mkDerivation rec {
  pname = "katifetch";
  version = "13.1";

  src = fetchFromGitHub {
    owner = "ximimoments";
    repo = "katifetch";
    rev = "main";
    sha256 = "sha256-Vboo0sGqywGNFxr4n++LOPX2gtXiXE/16oA0UFMRF0c=";
  };

  # Use makeWrapper to create a reliable entry point
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share/katifetch
    
    # Copy all files to the share directory
    cp -r . $out/share/katifetch/
    
    # Ensure the main script is executable
    chmod +x $out/share/katifetch/katifetch.sh
    
    # Create the binary using makeWrapper
    makeWrapper ${bash}/bin/bash $out/bin/katifetch \
      --run "cd $out/share/katifetch && ./katifetch.sh"
  '';

  meta = with lib; {
    description = "A custom fetch script";
    homepage = "https://github.com/ximimoments/katifetch";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ximimoments ];
  };
}
