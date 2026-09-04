{
  lib,
  rustPlatform,
  fetchFromCodeberg,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "emplace";
  version = "1.6.0-unstable-2025-03-09";

  __strucutredAttrs = true;

  src = fetchFromCodeberg {
    owner = "fosk";
    repo = "emplace";
    rev = "e1b16ff1621d0a417562b31ef2227130bfa3a155";
    hash = "sha256-v61mlhBH4Iqhdw39vvxYuRdSyaMT8EiaCn85+t2JyUc=";
  };

  cargoHash = "sha256-CBtbSMoae2mLCDYzDe4NhVJT7iwtgm8U7OflE5+IsJM=";

  meta = {
    description = "Mirror installed software on multiple machines";
    homepage = "https://codeberg.org/fosk/emplace";
    license = lib.licenses.agpl3Plus;
    mainProgram = "emplace";
  };
})
