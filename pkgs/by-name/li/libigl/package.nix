{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "libigl";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "libigl";
    repo = "libigl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OpjkQGRiuc7kNlwgCeM4dcotTb5J+6LUn4IOe9bFbW4=";
  };

  # We could also properly use CMake, but we would have to heavily patch it
  # to avoid configure-time downloads of many things.
  installPhase = ''
    mkdir -p $out/include
    cp -r include/igl $out/include
  '';

  meta = with lib; {
    description = "Simple C++ geometry processing library";
    homepage = "https://github.com/libigl/libigl";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nim65s ];
  };
})
