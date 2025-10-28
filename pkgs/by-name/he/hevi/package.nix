{
  callPackage,
  fetchFromGitHub,
  lib,
  stdenv,
  zig_0_13,
}:

let
  zig = zig_0_13;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hevi";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Arnau478";
    repo = "hevi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wnpuM2qlbeDIupDPQPKdWmjAKepCG0+u3uxcLDFB09w=";
  };

  nativeBuildInputs = [
    zig.hook
  ];

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  meta = {
    description = "Hex viewer";
    homepage = "https://github.com/Arnau478/hevi";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jmbaur ];
    mainProgram = "hevi";
    inherit (zig.meta) platforms;
  };
})
