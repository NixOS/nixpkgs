{
  lib,
  python3Packages,
  python3,
  fetchFromGitHub,
  makeWrapper,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "discord-rich-presence-plex";
  version = "3.0.0";
  pyproject = false;
  src = fetchFromGitHub {
    owner = "phin05";
    repo = "discord-rich-presence-plex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RvsS47059YdxKSo6sy+zglY1YxzyJmZTmo/DIKX1xqU=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];
  dontBuild = true;
  dontUseSetuptoolsBuild = true;
  dontUseSetuptoolsCheck = true;

  dependencies = with python3Packages; [
    requests
    pillow
    plexapi
    pyyaml
    websocket-client
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/discord-rich-presence-plex
    cp -r * $out/lib/discord-rich-presence-plex/

    mkdir -p $out/bin
    makeWrapper ${lib.getExe python3} \
      $out/bin/discord-rich-presence-plex \
      --add-flags "$out/lib/discord-rich-presence-plex/main.py" \
      --prefix PYTHONPATH : "$out/lib/discord-rich-presence-plex:$PYTHONPATH" \
      --set DRPP_NO_PIP_INSTALL "true"

    runHook postInstall
  '';

  # No tests
  doCheck = false;

  meta = {
    homepage = "https://github.com/phin05/discord-rich-presence-plex";
    changelog = "https://github.com/phin05/discord-rich-presence-plex/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    description = "Displays your Plex status on Discord using Rich Presence";
    maintainers = with lib.maintainers; [ hogcycle ];
    mainProgram = "discord-rich-presence-plex";
  };
})
