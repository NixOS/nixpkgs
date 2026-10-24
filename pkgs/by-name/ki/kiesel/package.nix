{
  callPackage,
  cargo,
  fetchFromCodeberg,
  lib,
  nix-update-script,
  rustc,
  rustPlatform,
  stdenv,
  zig_0_17,
}:
let
  zig = zig_0_17;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kiesel";
  version = "0.4.1";

  src = fetchFromCodeberg {
    owner = "kiesel-js";
    repo = "kiesel";
    tag = finalAttrs.version;
    hash = "sha256-7zBgB1+6q+6af+vNWTUYPaFYe/Rxht+lHeB20jHhyt8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    src = "${finalAttrs.src}/pkg/zement";
    hash = "sha256-c5uLe3Ko90Kn9peqkk5vAicBGT7uj3OeRtOH33qQ/kQ=";
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
    maintainers = with lib.maintainers; [ cve ];
    platforms = lib.platforms.all;
    mainProgram = "kiesel";
  };
})
