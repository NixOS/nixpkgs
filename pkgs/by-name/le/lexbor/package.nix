{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lexbor";
  version = "2.6.0-unstable-2026-03-04";

  src = fetchFromGitHub {
    owner = "lexbor";
    repo = "lexbor";
    rev = "e82094607d345c639184e775d4b3ecbb2503b739";
    hash = "sha256-4zEfUME9PIg6fu2BV5HKQwXdSICm51sUsS7kYoC/ghI=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Open source HTML Renderer library";
    homepage = "https://github.com/lexbor/lexbor";
    changelog = "https://github.com/lexbor/lexbor/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "lexbor";
    platforms = lib.platforms.all;
  };
})
