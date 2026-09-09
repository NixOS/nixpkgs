{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "libigl";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "libigl";
    repo = "libigl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uef7aTF2U3iPVAWDGRIsH0YV0l/w8VxtYFPYVkuC1dI=";
  };

  # We could also properly use CMake, but we would have to heavily patch it
  # to avoid configure-time downloads of many things.
  installPhase = ''
    mkdir -p $out/include
    cp -r include/igl $out/include
    rm -rf $out/include/igl/opengl
  '';

  meta = {
    description = "Simple C++ geometry processing library";
    homepage = "https://github.com/libigl/libigl";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
