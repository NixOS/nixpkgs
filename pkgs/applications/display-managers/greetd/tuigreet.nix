{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "tuigreet";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "apognu";
    repo = pname;
    rev = version;
    sha256 = "sha256-o1NPwZ2gvFxq988RhLz/6ucL4qb2dGtMdhNvAbQzIvg=";
  };

  cargoSha256 = "sha256-dfzNRs3NOtHoWBq6tx3DjL2knNwsdxBmjqJbPzQJifQ=";

  meta = with lib; {
    description = "Graphical console greeter for greetd";
    homepage = "https://github.com/apognu/tuigreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
    mainProgram = "tuigreet";
  };
}
