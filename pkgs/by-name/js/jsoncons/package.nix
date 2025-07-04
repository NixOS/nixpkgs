{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jsoncons";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "danielaparker";
    repo = "jsoncons";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q7qtLLTvJcIFPSx6MkS7SI89MBcM88g3KmX/b3BAKwI=";
  };

  nativeBuildInputs = [ cmake ];

  env.NIX_CFLAGS_COMPILE = "-std=c++20 -Wno-error";

  meta = {
    description = "C++, header-only library for constructing JSON and JSON-like data formats";
    homepage = "https://danielaparker.github.io/jsoncons/";
    changelog = "https://github.com/danielaparker/jsoncons/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.all;
  };
})
