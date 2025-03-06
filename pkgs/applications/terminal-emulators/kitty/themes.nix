{ lib
, stdenvNoCC
, fetchFromGitHub
, unstableGitUpdater
}:

stdenvNoCC.mkDerivation {
  pname = "kitty-themes";
  version = "0-unstable-2025-03-03";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty-themes";
    rev = "31e91816bc5af6c819312d2c783f2949afa4b07a";
    hash = "sha256-DiP/YZIxVjuk4Q7eNajM/dY/LIY3rs3GG7S9lFqplag=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/kitty-themes/ themes.json
    mv themes $out/share/kitty-themes

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    homepage = "https://github.com/kovidgoyal/kitty-themes";
    description = "Themes for the kitty terminal emulator";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.all;
  };
}
