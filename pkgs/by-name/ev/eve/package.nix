{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eve";
  version = "2023.02.15";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "jfalcou";
    repo = "eve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k7dDtLR9PoJp9SR0z4j6uNwm8JOJQiHXbr09kXtRJ7g=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    changelog = "https://github.com/jfalcou/eve/releases/tag/${finalAttrs.src.tag}";
    description = "Expressive Vector Engine";
    homepage = "https://jfalcou.github.io/eve";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ hythera ];
    platforms = lib.platforms.all;
  };
})
