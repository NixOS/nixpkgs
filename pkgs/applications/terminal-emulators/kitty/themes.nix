{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "kitty-themes";
  version = "unstable-2023-12-28";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty-themes";
    rev = "46d9dfe230f315a6a0c62f4687f6b3da20fd05e4";
    hash = "sha256-jlYim4YXByT6s6ce0TydZuhX0Y1ZDcAq2XKNONisSzE=";
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
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
}
