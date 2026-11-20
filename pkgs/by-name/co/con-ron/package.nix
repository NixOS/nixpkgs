{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "con-ron";
  version = "0-unstable-2026-11-18";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "con-ron";
    rev = "c77150ee9c51256a2e6ff5363b2e026e30126fe6";
    hash = "sha256-50FcX5lABMekRUjDVUWXBLf8ZqxaacYX7vm7CBnVREY=";
  };

  cargoHash = "sha256-cxUCIOZDmZ1F2YoNQ2+C5XRUxPowGHZdVJ7ZPhnOjUc=";

  meta = {
    description = "Rust port of con-leche";
    license = lib.licenses.asl20;
    homepage = "https://github.com/leanprover/con-ron";
    maintainers = with lib.maintainers; [
      alejo7797
      stephen-huan
    ];
  };
}
