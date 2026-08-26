{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libopenaptx";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "pali";
    repo = "libopenaptx";
    rev = finalAttrs.version;
    sha256 = "sha256-4FYKxw1U+efCfzKOPSDJH8a/dG0KV+anJDgxjqzD80k=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    # disable static builds
    "ANAME="
    "AOBJECTS="
    "STATIC_UTILITIES="
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Audio Processing Technology codec (aptX)";
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/pali/libopenaptx";
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
