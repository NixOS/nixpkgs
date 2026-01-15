{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  python3,
  python3Packages,
}:

stdenvNoCC.mkDerivation {
  pname = "mint-l-theme";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-l-theme";
    # They don't really do tags, this is just a named commit.
    rev = "112daa4f76ccef08a9c4e3b107957ff862429516";
    hash = "sha256-Y6rPrEG+Gh2V+TbLDTqVgPSYQMBXWKacYrS1FMzmQVo=";
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
