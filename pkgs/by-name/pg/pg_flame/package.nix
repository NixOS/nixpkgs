{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pg_flame";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "mgartner";
    repo = "pg_flame";
    rev = "v${finalAttrs.version}";
    hash = "sha256-glvIv9GHIbp6IZUvZo9fyvkJ6QR03nMlrAOpZ3HfA6g=";
  };

  vendorHash = "sha256-ReVaetR3zkLLLc3d0EQkBAyUrxwBn3iq8MZAGzkQfeY=";

  meta = {
    description = "Flamegraph generator for Postgres EXPLAIN ANALYZE output";
    homepage = "https://github.com/mgartner/pg_flame";
    license = lib.licenses.asl20;
    mainProgram = "pg_flame";
  };
})
