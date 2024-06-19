{ stdenv, lib, fetchFromGitHub, fftw
, qtbase, qmake, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "smartdeblur";
  version = "unstable-2018-10-29";

  src = fetchFromGitHub {
    owner = "Y-Vladimir";
    repo = "SmartDeblur";
    rev = "5af573c7048ac49ef68e638f3405d3a571b96a8b";
    sha256 = "151vdd5ld0clw0vgp0fvp2gp2ybwpx9g43dad9fvbvwkg60izs87";
  };

  sourceRoot = "${src.name}/src";

  nativeBuildInputs = [ qmake wrapQtAppsHook ];
  buildInputs = [ qtbase fftw ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ./SmartDeblur -t $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/Y-Vladimir/SmartDeblur";
    description = "Tool for restoring blurry and defocused images";
    mainProgram = "SmartDeblur";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
