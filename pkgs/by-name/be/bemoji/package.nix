{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "bemoji";
  version = "0.4.0-unstable-2024-04-28";

  src = fetchFromGitHub {
    owner = "marty-oehme";
    repo = "bemoji";
    rev = "1b5e9c1284ede59d771bfd43780cc8f6f7446f38";
    hash = "sha256-WD4oFq0NRZ0Dt/YamutM7iWz3fMRxCqwgRn/rcUsTIw=";
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
    maintainers = with maintainers; [
      laurent-f1z1
      MrSom3body
    ];
  };
}
