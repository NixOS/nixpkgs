{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "loguru";
  version = "2.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "emilk";
    repo = "loguru";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b1aBpeIsHd/RxQkWZFFYnbg7yHI14Rfnz7k6C65vgq0=";
  };

  cmakeFlags = [
    "-DLOGURU_WITH_STREAMS=1"
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Lightweight C++ logging library";
    homepage = "https://github.com/emilk/loguru";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.all;
  };
})
