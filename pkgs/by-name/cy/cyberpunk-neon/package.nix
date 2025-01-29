{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unzip,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "cyberpunk-neon";
  version = "0-unstable-2024-11-07";

  src = fetchFromGitHub {
    owner = "Roboron3042";
    repo = "Cyberpunk-Neon";
    rev = "f036cc70f39caa91b8ff1dab16194a97848ee378";
    hash = "sha256-PmCzTj9TfFzilO+Sf976hhcBwUq7qyG1+HbwwBD777o=";
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
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
}
