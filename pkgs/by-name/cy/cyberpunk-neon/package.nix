{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unzip,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "cyberpunk-neon";
  version = "0-unstable-2025-05-05";

  src = fetchFromGitHub {
    owner = "Roboron3042";
    repo = "Cyberpunk-Neon";
    rev = "e74c25c8507bbbb23d81d075402bd983a61ebe07";
    hash = "sha256-LzoSC9O6173YcKvMWkSKkxsUVCZYMA844FnDfdr1gVc=";
  };

  outputs = [
    "out"
    "gtk"
    "kde"
    "konsole"
    "tilix"
  ];

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    install -Dt $out/share/doc/cyberpunk-neon/ README.md

    mkdir -p $gtk/share/themes
    unzip gtk/materia-cyberpunk-neon.zip -d $gtk/share/themes/
    unzip gtk/oomox-cyberpunk-neon.zip -d $gtk/share/themes/

    install -Dt $kde/share/color-schemes kde/cyberpunk-neon.colors

    install -Dt $konsole/share/konsole terminal/konsole/cyberpunk-neon.colorscheme

    install -Dt $tilix/share/tilix/schemes terminal/tilix/cyberpunk-neon.json

    runHook postInstall
  '';

  strictDeps = true;

  passthru = {
    updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
  };

  meta = {
    homepage = "https://github.com/Roboron3042/Cyberpunk-Neon";
    description = "Neon themes for many programs";
    license = lib.licenses.cc-by-sa-40;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
