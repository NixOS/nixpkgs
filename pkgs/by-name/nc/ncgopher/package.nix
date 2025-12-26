{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  ncurses6,
  openssl,
  sqlite,
  perl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ncgopher";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "jansc";
    repo = "ncgopher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9bwQgFZkwOV28qflWL7ZyUE3SLvPhf77sjomurqMK6E=";
  };

  cargoHash = "sha256-wfodxA1fvdsvWvmnzYmL4GzgdIiQbXuhGq/U9spM+0s=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [
    ncurses6
    openssl
    sqlite
  ];

  meta = {
    description = "Gopher and gemini client for the modern internet";
    homepage = "https://github.com/jansc/ncgopher";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ shamilton ];
    platforms = lib.platforms.linux;
    mainProgram = "ncgopher";
  };
})
