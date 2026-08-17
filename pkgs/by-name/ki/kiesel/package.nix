{
  callPackage,
  cargo,
  fetchFromCodeberg,
  lib,
  nix-update-script,
  rustc,
  rustPlatform,
  stdenv,
  zig_0_16,
}:
let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kiesel";
  version = "0.2.0";

  src = fetchFromCodeberg {
    owner = "kiesel-js";
    repo = "kiesel";
    tag = finalAttrs.version;
    hash = "sha256-bddGd3LPmVV8wwoVHYJJKoHS6ssYyU1hQBTGJBQJPgc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    src = "${finalAttrs.src}/pkg/zement";
    hash = "sha256-SOp8UW0iKniXwzEGGtzX5rFAdVQKDHoEvCupquusvmo=";
  };
  cargoRoot = "pkg/zement";
  deps = callPackage ./deps.nix { };
  strictDeps = true;

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
    zig.hook
  ];

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ];

  __structuredAttrs = true;
  passthru.tests.run = callPackage ./test.nix { kiesel = finalAttrs.finalPackage; };
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "JavaScript engine written in Zig";
    license = lib.licenses.mit;
    homepage = "https://kiesel.dev";
    maintainers = with lib.maintainers; [ cvengler ];
    platforms = lib.platforms.all;
    mainProgram = "kiesel";
  };
})
