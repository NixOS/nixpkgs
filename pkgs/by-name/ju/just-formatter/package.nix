{
  fetchCrate,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "just-formatter";
  version = "1.1.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-HTv55WquFieWmkEKX5sbBOVyYxzjcB/NrMkxbQsff90=";
  };

  cargoHash = "sha256-pJVvA2uzZzU5Rvh20gosYeasgCB6GAUjaWwqGWvLqAc=";

  meta = {
    homepage = "https://github.com/eli-yip/just-formatter";
    description = "Format justfile from stdin to stdout";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vuimuich ];
    mainProgram = "just-formatter";
  };
}
