{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  python3,
  python3Packages,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-themes";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-themes";
    rev = version;
    hash = "sha256-ULrbYE7KCuAGuPZOJAOqerggFET/rSgbFO3GxbPf61Q=";
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
