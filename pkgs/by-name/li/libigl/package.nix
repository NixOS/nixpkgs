{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "libigl";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "libigl";
    repo = "libigl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7Cvz/yOb5kQaIceUwyijBNplXvok5reJoJsTnvKWt4M=";
  };

  # We could also properly use CMake, but we would have to heavily patch it
  # to avoid configure-time downloads of many things.
  installPhase = ''
    mkdir -p $out/include
    cp -r include/igl $out/include
    rm -rf $out/include/igl/opengl
  '';

  meta = with lib; {
    description = "Simple C++ geometry processing library";
    homepage = "https://github.com/libigl/libigl";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nim65s ];
  };
})
