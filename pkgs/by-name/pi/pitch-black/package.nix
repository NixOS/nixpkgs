{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "pitch-black";
  version = "0-unstable-2019-07-23";

  src = fetchFromGitHub {
    repo = "pitch-black";
    owner = "freefreeno";
    rev = "d8039341419aef1157c030bf3d9237bd926e0b95";
    hash = "sha256-Rn3ZMBD6srIkYFNN3HT5JFP46Akodmeqz5tbV2/2ZDA=";
  };

  dontBuild = true;

  installPhase = ''
    rm LICENSE README.md
    mkdir -p $out/share
    mv GTK $out/share/themes
    mv * $out/share
  '';

<<<<<<< HEAD
  meta = {
    description = "Dark plasma theme built with usability in mind";
    homepage = "https://github.com/freefreeno/Pitch-Black";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.pasqui23 ];
=======
  meta = with lib; {
    description = "Dark plasma theme built with usability in mind";
    homepage = "https://github.com/freefreeno/Pitch-Black";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.pasqui23 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
