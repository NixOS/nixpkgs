{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  plutovg,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lunasvg";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "sammycage";
    repo = "lunasvg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CBhz117Y8e7AdD1JJtNkR/EthsfyiQ05HW41beaY95I=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    plutovg
  ];

  patches = [
    # https://github.com/sammycage/lunasvg/pull/219
    # can be removed when the PR 219 and a new release is created
    ./use_system_plutovg.patch
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_PLUTOVG" true)
  ];

  meta = {
    homepage = "https://github.com/sammycage/lunasvg";
    changelog = "https://github.com/sammycage/lunasvg/releases/tag/v${finalAttrs.version}";
    description = "SVG rendering and manipulation library in C++";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.eymeric ];
    platforms = lib.platforms.all;
  };
})
