{
  lib,
  buildLua,
  fetchFromGitHub,
  gitUpdater,
  curl,
  wl-clipboard,
  xclip,
}:

buildLua rec {
  pname = "mpvacious";
  version = "0.34";

  src = fetchFromGitHub {
    owner = "Ajatt-Tools";
    repo = "mpvacious";
    rev = "v${version}";
    sha256 = "sha256-YsbeMWGpRi9wUdnrMA2YQXXWQUALxDOTs+gBJ56okkI=";
  };
  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  postPatch = ''
    substituteInPlace utils/forvo.lua \
      --replace-fail "'curl" "'${lib.getExe curl}"
    substituteInPlace platform/nix.lua \
      --replace-fail "'curl" "'${lib.getExe curl}" \
      --replace-fail "'wl-copy" "'${lib.getExe' wl-clipboard "wl-copy"}" \
      --replace-fail "'xclip" "'${lib.getExe xclip}"
  '';

  installPhase = ''
    runHook preInstall
    make PREFIX=$out/share/mpv install
    runHook postInstall
  '';

  passthru.scriptName = "mpvacious";

  meta = with lib; {
    description = "Adds mpv keybindings to create Anki cards from movies and TV shows";
    homepage = "https://github.com/Ajatt-Tools/mpvacious";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kmicklas ];
  };
}
