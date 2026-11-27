{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "con-ron";
  version = "0.1.0-unstable-2026-10-05";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "con-ron";
    # https://github.com/leanprover/lean4/blob/v{version}/src/CMakeLists.txt
    rev = "dd8d8218892c871276b1e569d3decbb368bba1b6";
    hash = "sha256-zoUlAhoZeQ4rEb+hOI/kS2MV/82ytdl1lLuXHFq2ogw=";
  };

  cargoHash = "sha256-cxUCIOZDmZ1F2YoNQ2+C5XRUxPowGHZdVJ7ZPhnOjUc=";

  meta = with lib; {
    description = "Rust port of con-leche";
    homepage = "https://github.com/leanprover/con-ron";
    license = lib.licenses.asl20;
    mainProgram = "con-ron";
    maintainers = with maintainers; [ stephen-huan ];
  };
})
