{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "kitty-themes";
  version = "unstable-2023-06-01";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty-themes";
    rev = "f765eb1715d79c6cb3ad3d571342d612f21b810e";
    hash = "sha256-Y3N8cyqEsY/kB2xMIlPYnbuYUs8grzepPx/11maG4bo=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/kitty-themes/ themes.json
    mv themes $out/share/kitty-themes

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/kovidgoyal/kitty-themes";
    description = "Themes for the kitty terminal emulator";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ AndersonTorres nelsonjeppesen ];
    platforms = lib.platforms.all;
  };
}
