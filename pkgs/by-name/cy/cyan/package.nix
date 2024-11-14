{ lib
, stdenv
, fetchFromGitHub
, qt5
, cmake
, pkg-config
, imagemagick
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "cyan";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "rodlie";
    repo = pname;
    rev = version;
    hash = "sha256-R5sj8AN7UT9OIeUPNrdTIUQvtEitXp1A32l/Z2qRS94=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt5.wrapQtAppsHook
  ];

  buildInputs = [ imagemagick ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Image viewer and converter, designed for prepress (print) work";
    homepage = "https://github.com/rodlie/cyan";
    mainProgram = "Cyan";
    license = licenses.cecill21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
