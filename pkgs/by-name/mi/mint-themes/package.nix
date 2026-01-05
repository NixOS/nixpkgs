{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  python3,
  python3Packages,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-themes";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-themes";
    rev = version;
    hash = "sha256-99bE20XheHzEa2IIlXqdTHs044FRqI3O1xOLkhEC/gY=";
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

  meta = with lib; {
    homepage = "https://github.com/linuxmint/mint-themes";
    description = "Mint-X and Mint-Y themes for the cinnamon desktop";
    license = licenses.gpl3; # from debian/copyright
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
  };
}
