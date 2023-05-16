{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "kitty-themes";
<<<<<<< HEAD
  version = "unstable-2023-06-01";
=======
  version = "unstable-2023-03-08";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty-themes";
<<<<<<< HEAD
    rev = "f765eb1715d79c6cb3ad3d571342d612f21b810e";
    hash = "sha256-Y3N8cyqEsY/kB2xMIlPYnbuYUs8grzepPx/11maG4bo=";
=======
    rev = "c01fcbd694353507c3cc7f657179bad1f32140a7";
    hash = "sha256-heJayOz/2Bey/zAwL2PR1OsfGyCPqMyxT1XzwHLhQ0w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
