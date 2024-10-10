{ lib
, stdenvNoCC
, fetchFromGitHub
, unstableGitUpdater
}:

stdenvNoCC.mkDerivation {
  pname = "kitty-themes";
  version = "0-unstable-2024-10-06";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty-themes";
    rev = "821474ff2d20543180c470da31c41d75c6e8afbc";
    hash = "sha256-ka0YDXqocN32RceTyhhR/TsEmeV7V/JrL6qWDS5TY90=";
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
