{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "kitty-themes";
  version = "unstable-2023-03-08";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty-themes";
    rev = "c01fcbd694353507c3cc7f657179bad1f32140a7";
    hash = "sha256-heJayOz/2Bey/zAwL2PR1OsfGyCPqMyxT1XzwHLhQ0w=";
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
