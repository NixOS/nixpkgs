{ lib
, stdenvNoCC
, fetchFromGitHub
, unstableGitUpdater
}:

stdenvNoCC.mkDerivation {
  pname = "kitty-themes";
  version = "0-unstable-2024-08-14";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty-themes";
    rev = "cdf1ed4134815f58727f8070f997552f86b58892";
    hash = "sha256-vt5y3Ai1KMgRhFrkfhA8G9Ve6BEFrgkCF3ssGlOdekw=";
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
