{
  stdenv,
  lib,
  fetchFromGitHub,
  libx11,
  cairo,
  lv2,
  libsndfile,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bangr";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = "BAngr";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    sha256 = "sha256-tit0lF/LqHu3eAtkJj4lo3FfvArOy56JqjtxrzCLJdo=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libx11
    cairo
    lv2
    libsndfile
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/sjaehn/BAngr";
    description = "Multi-dimensional dynamically distorted staggered multi-bandpass LV2 plugin";
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
  };
})
