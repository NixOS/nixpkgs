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
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-l-theme";
    rev = version;
    hash = "sha256-QPTU/wCOytleuiQAodGzZ1MGWD2Sk7eoeXWpi6nS5As=";
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

  meta = {
    homepage = "https://github.com/linuxmint/mint-l-theme";
    description = "Mint-L theme for the Cinnamon desktop";
    license = lib.licenses.gpl3Plus; # from debian/copyright
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
}
