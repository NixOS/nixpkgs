{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  python3,
  python3Packages,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-l-theme";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-l-theme";
    rev = version;
    hash = "sha256-jrNVeeqOBDf77Lz68qyjHllA4C3PQRySYQH7Sva2UHU=";
  };

  nativeBuildInputs = [
    python3
    python3Packages.libsass
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
