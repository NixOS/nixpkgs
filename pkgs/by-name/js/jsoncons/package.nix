{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jsoncons";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "danielaparker";
    repo = "jsoncons";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OhXcHMec+cExLLl0GuXoro93u1w/BTLY5bBh+4uUK5s=";
  };

  nativeBuildInputs = [ cmake ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=tautological-overlap-compare";

  meta = {
    description = "C++, header-only library for constructing JSON and JSON-like data formats";
    homepage = "https://danielaparker.github.io/jsoncons/";
    changelog = "https://github.com/danielaparker/jsoncons/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.all;
  };
})
