{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "gits";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "pompydev";
    repo = "gits";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+mYqjq0P4sI7Ol5IpftCgxM4dKacw8Ohg2mkBHAKsbY=";
  };

  cargoHash = "sha256-J9OrpVhPbIIhDxXmqwfFO4UcnVLZq5/xMrX5dRaJtkQ=";

  meta = {
    description = "git stats as TUI";
    homepage = "https://github.com/pompydev/gits";
    license = with lib.licenses; [ agpl3Plus ];
    maintainers = with lib.maintainers; [ pompydev ];
    mainProgram = "gits";
    platforms = lib.platforms.all;
  };
})
