{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "hanken-grotesk";
  version = "0-unstable-2024-01-30";

  src = fetchFromGitHub {
    owner = "marcologous";
    repo = "hanken-grotesk";
    rev = "1ab416e82130b2d3ddb7710abf7ceabf07156a13";
    hash = "sha256-CgxqC+4QrjdsB7VdAMneP8ND9AsWPVI8d8UOn4kytxs=";
  };

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/share/fonts
    cp --recursive fonts/ttf $out/share/fonts/truetype
    cp --recursive fonts/variable $out/share/fonts/variable

    runHook postInstall
  '';

  meta = {
    description = "Hanken Grotesk typeface";
    longDescription = "Hanken Grotesk is a sans serif typeface inspired by the classic grotesques.";
    homepage = "https://github.com/marcologous/hanken-grotesk";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bricked ];
  };
}
