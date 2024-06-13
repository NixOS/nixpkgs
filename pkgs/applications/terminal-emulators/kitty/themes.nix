{ lib
, stdenvNoCC
, fetchFromGitHub
, unstableGitUpdater
}:

stdenvNoCC.mkDerivation {
  pname = "kitty-themes";
  version = "0-unstable-2024-06-12";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty-themes";
    rev = "9589f0dffc817d6e8b86a5b2dc56d7c3db201a9b";
    hash = "sha256-8bZkYFb/HOIg2Uk7b/Apn30AAlRF0ztLh27AUlHW6Wk=";
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
