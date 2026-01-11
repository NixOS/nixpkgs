{
  fetchFromGitHub,
  lib,
  stdenv,
  cmake,
  coin3d,
  motif,
  libXext,
  libXmu,
  libGLU,
  libGL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soxt";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "coin3d";
    repo = "soxt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ji3rukL8QOErsjx06A61d65O5wxhw4jkEEKIa4EDhUg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    coin3d
    motif
    libGLU
    libGL
    libXext
    libXmu
  ];

  meta = {
    homepage = "https://bitbucket.org/Coin3D/coin/wiki/Home";
    license = lib.licenses.bsd3;
    description = "GUI binding for using Open Inventor with Xt/Motif";
    maintainers = with lib.maintainers; [
      tmplt
      skohtv
    ];
    platforms = lib.platforms.linux;
  };
})
