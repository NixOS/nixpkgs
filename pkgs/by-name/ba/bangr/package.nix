{
  stdenv,
  lib,
  fetchFromGitHub,
  libx11,
  cairo,
  cpio,
  lv2,
  libsndfile,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bangr";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = "BAngr";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    sha256 = "sha256-od1UPriojDQHrAWzCYjuNoz27MRGIe+NvntUEFgGGWE=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libx11
    cairo
    cpio
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
