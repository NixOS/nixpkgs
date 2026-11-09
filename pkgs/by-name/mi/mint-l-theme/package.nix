{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  python3,
  python3Packages,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mint-l-theme";
  version = "2.0.10";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-l-theme";
    tag = finalAttrs.version;
    hash = "sha256-Es69RjHMTGJ3NGaRY/mmF6RI5JAofzJisx4EolvhFlA=";
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
})
