{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "elfcat";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "ruslashev";
    repo = "elfcat";
    rev = version;
    sha256 = "sha256-8jyOYV455APlf8F6HmgyvgfNGddMzrcGhj7yFQT6qvg=";
  };

  cargoHash = "sha256-oVl+40QunvKZIbhsOgqNTsvWduCXP/QJ0amT8ECSsMU=";

  meta = with lib; {
    description = "ELF visualizer, generates HTML files from ELF binaries";
    homepage = "https://github.com/ruslashev/elfcat";
    license = licenses.zlib;
    maintainers = with maintainers; [ moni ];
    mainProgram = "elfcat";
  };
}
