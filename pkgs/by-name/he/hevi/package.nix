{
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

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-B3ps6AfYdcbSNiVuhJQWrjHxknoKmYL8jdbBVr4lINY=";
  };

  meta = {
    description = "Hex viewer";
    homepage = "https://github.com/Arnau478/hevi";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jmbaur ];
    mainProgram = "hevi";
    inherit (zig.meta) platforms;
  };
})
