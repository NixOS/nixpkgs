{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "bemoji";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "marty-oehme";
    repo = "bemoji";
    tag = "v${version}";
    hash = "sha256-HXwho0vRI9ZrUuDMicMH4ZNExY+zJfbrne2LMQmmHww=";
  };

  strictDeps = true;
  dontBuild = true;

  postInstall = ''
    install -Dm555 bemoji -t $out/bin
  '';

  meta = {
    homepage = "https://github.com/marty-oehme/bemoji/";
    description = "Emoji picker with support for bemenu/wofi/rofi/dmenu and wayland/X11";
    license = lib.licenses.mit;
    mainProgram = "bemoji";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ laurent-f1z1 ];
  };
}
