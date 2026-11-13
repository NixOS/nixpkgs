{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lethe";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "kostassoid";
    repo = "lethe";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-YDPD+7ZWNWL+/3o6BfIxAkzuXFlqjur6cNJlMgKKERA=";
  };

  cargoHash = "sha256-7YQ+fBdz10HT5/AlxWSC7uMMlV4hCiY29bKgjUSgc44=";

  meta = {
    description = "Tool to wipe drives in a secure way";
    homepage = "https://github.com/kostassoid/lethe";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "lethe";
  };
})
