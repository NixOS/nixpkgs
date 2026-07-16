{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cglm";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "recp";
    repo = "cglm";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-caDw9Sqf4hS2JNbNxG/xaFIvO6oIlvT+hZQhdX37BKw=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '\$'{prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace '\$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR}
  '';

  meta = {
    homepage = "https://github.com/recp/cglm";
    description = "Highly Optimized Graphics Math (glm) for C";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
