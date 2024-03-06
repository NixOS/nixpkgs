{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "clipse";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "savedra1";
    repo = "clipse";
    rev = "v0.0.6";
    hash = "sha256-zCsSfnZbhOYe1ysnGFO6VYZKVYCNZY0DvP2FB3EXFDM=";
  };

  vendorHash = "sha256-GIUEx4h3xvLySjBAQKajby2cdH8ioHkv8aPskHN0V+w=";

  meta = with lib; {
    description = "A useful clipboard manager TUI for Unix.";
    homepage = "https://github.com/savedra1/clipse";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ "savedra1" ];
    mainProgram = "clipse";
  };
}
