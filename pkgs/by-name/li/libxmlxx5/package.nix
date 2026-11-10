{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libxml2,
  glibmm_2_4,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxmlxx5";
  version = "5.6.1";

  src = fetchFromGitHub {
    owner = "libxmlplusplus";
    repo = "libxmlplusplus";
    tag = finalAttrs.version;
    hash = "sha256-f8R2T5A7C/HqydhZOlbWIKj6Q9oc97f2PfV8ef70G0I=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [ glibmm_2_4 ];

  propagatedBuildInputs = [ libxml2 ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = {
    changelog = "https://github.com/libxmlplusplus/libxmlplusplus/blob/${finalAttrs.src.tag}/NEWS";
    description = "C++ wrapper for the libxml2 XML parser library";
    homepage = "https://libxmlplusplus.github.io/libxmlplusplus";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
