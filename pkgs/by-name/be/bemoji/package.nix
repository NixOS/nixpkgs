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
    rev = "refs/tags/v${version}";
    hash = "sha256-HXwho0vRI9ZrUuDMicMH4ZNExY+zJfbrne2LMQmmHww=";
  };

  strictDeps = true;
  dontBuild = true;

  postInstall = ''
    install -Dm555 bemoji -t $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/marty-oehme/bemoji/";
    description = "Emoji picker with support for bemenu/wofi/rofi/dmenu and wayland/X11";
    license = licenses.mit;
    mainProgram = "bemoji";
    platforms = platforms.all;
    maintainers = with maintainers; [ laurent-f1z1 ];
  };
}
