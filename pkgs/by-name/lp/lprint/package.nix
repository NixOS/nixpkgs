{ lib, stdenv, fetchFromGitHub
, pappl
, cups
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "lprint";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1OOLGQ8S4oRNSJanX/AzJ+g5F+jYnE/+o+ie5ucY22U=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    pappl
    cups
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/lprint --help
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "LPrint implements printing for a variety of common label and receipt printers connected via network or USB";
    mainProgram = "lprint";
    homepage = "https://github.com/michaelrsweet/lprint";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
