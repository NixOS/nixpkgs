{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  python3,
  sassc,
  sass,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-l-theme";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-l-theme";
    rev = version;
    hash = "sha256-3suLa8el58t5J6aJaH3Z4+tTqoCpD1Uvy2uzaVgIfVo=";
  };

  nativeBuildInputs = [
    python3
    sassc
    sass
  ];

  postPatch = ''
    patchShebangs .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv usr/share $out

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/mint-l-theme";
    description = "Mint-L theme for the Cinnamon desktop";
    license = licenses.gpl3Plus; # from debian/copyright
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
  };
}
