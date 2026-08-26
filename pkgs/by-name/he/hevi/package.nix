{
  callPackage,
  fetchFromCodeberg,
  lib,
  stdenv,
  zig_0_16,
}:

let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hevi";
  version = "1.1.0-unstable-2026-05-03";

  src = fetchFromCodeberg {
    owner = "arnauc";
    repo = "hevi";
    rev = "3c6f08ec73ac56673321f0449d4ae0a74b7674a9";
    hash = "sha256-5i1Fe3/AYFu4HKQSXBWsdYDNl+FCp7QOZJ0eX1bw3f8=";
  };

  nativeBuildInputs = [
    zig
  ];

  deps = callPackage ./deps.nix { };
  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ];

  meta = {
    description = "Hex viewer";
    homepage = "https://codeberg.org/arnauc/hevi";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jmbaur ];
    mainProgram = "hevi";
    inherit (zig.meta) platforms;
  };
})
