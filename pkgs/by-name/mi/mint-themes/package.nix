{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  python3,
  python3Packages,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-themes";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-themes";
    rev = version;
    hash = "sha256-pO2qotVR48VTKIS1IDqb9GwKTo/l1BV1Hk0w4Pf5V+U=";
  };

  nativeBuildInputs = [
    python3
    python3Packages.libsass
  ];

  preBuild = ''
    patchShebangs .
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    mv usr/share $out
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/linuxmint/mint-themes";
    description = "Mint-X and Mint-Y themes for the cinnamon desktop";
    license = lib.licenses.gpl3; # from debian/copyright
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
}
