{ lib, stdenv, fetchFromGitHub, electron, runtimeShell } :

stdenv.mkDerivation rec {
  pname = "nix-tour";
  version = "0.0.1";

  buildInputs = [ electron ];

  src = fetchFromGitHub {
    owner = "nixcloud";
    repo = "tour_of_nix";
    rev = "v${version}";
    sha256 = "sha256-a/P2ZMc9OpM4PxRFklSO6oVCc96AGWkxtGF/EmnfYSU=";
  };

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share
    cp -R * $out/share
    chmod 0755 $out/share/ -R
    echo "#!${runtimeShell}" > $out/bin/nix-tour
    echo "cd $out/share/" >> $out/bin/nix-tour
    echo "${electron}/bin/electron $out/share/electron-main.js" >> $out/bin/nix-tour
    chmod 0755 $out/bin/nix-tour
  '';

  meta = with lib; {
    description = "'the tour of nix' from nixcloud.io/tour as offline version";
    homepage = "https://nixcloud.io/tour";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ qknight ];
  };

}
