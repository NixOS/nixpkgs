{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "elfcat";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "ruslashev";
    repo = "elfcat";
    rev = finalAttrs.version;
    sha256 = "sha256-8jyOYV455APlf8F6HmgyvgfNGddMzrcGhj7yFQT6qvg=";
  };

  cargoHash = "sha256-oVl+40QunvKZIbhsOgqNTsvWduCXP/QJ0amT8ECSsMU=";

  meta = {
    description = "ELF visualizer, generates HTML files from ELF binaries";
    homepage = "https://github.com/ruslashev/elfcat";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ moni ];
    mainProgram = "elfcat";
  };
})
