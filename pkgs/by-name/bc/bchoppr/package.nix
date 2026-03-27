{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cairo,
  libx11,
  lv2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bchoppr";
  version = "1.12.6";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = "bchoppr";
    tag = finalAttrs.version;
    hash = "sha256-/aLoLUpWu66VKd9lwjli+FZZctblrZUPSEsdYH85HwQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    cairo
    libx11
    lv2
  ];

  installFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/sjaehn/BChoppr";
    description = "Audio stream chopping LV2 plugin";
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
  };
})
