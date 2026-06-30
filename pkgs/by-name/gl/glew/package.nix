{
  lib,
  stdenv,
  fetchurl,
  cmake,
  libGLU,
  libxmu,
  libxi,
  libxext,
  enableEGL ? (!stdenv.hostPlatform.isDarwin),
  testers,
  mesa,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glew";
  version = "2.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/glew/glew-${finalAttrs.version}.tgz";
    hash = "sha256-tkeQ+UuSas1+j4TF1gAKhstDlnvR5oiwMIkHl5nJ6Ik=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libxmu
    libxi
    libxext
  ];
  propagatedBuildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ libGLU ]; # GL/glew.h includes GL/glu.h

  cmakeDir = "cmake";
  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ]
  ++ lib.optional enableEGL "-DGLEW_EGL=ON";

  postInstall = ''
    moveToOutput lib/cmake "''${!outputDev}"
    moveToOutput lib/pkgconfig "''${!outputDev}"

    cat >> "''${!outputDev}"/lib/cmake/glew/glew-config.cmake <<EOF
    # nixpkg's workaround for a cmake bug
    # https://discourse.cmake.org/t/the-findglew-cmake-module-does-not-set-glew-libraries-in-some-cases/989/3
    set(GLEW_VERSION "$version")
    set(GLEW_LIBRARIES GLEW::glew\''${_glew_target_postfix})
    get_target_property(GLEW_INCLUDE_DIRS GLEW::glew\''${_glew_target_postfix} INTERFACE_INCLUDE_DIRECTORIES)
    set_target_properties(GLEW::GLEW\''${_glew_target_postfix} PROPERTIES
        IMPORTED_LINK_INTERFACE_LIBRARIES_RELEASE ""
        IMPORTED_IMPLIB_RELEASE "GLEW"
        IMPORTED_IMPLIB_DEBUG "GLEW"
    )
    EOF
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "OpenGL extension loading library for C/C++";
    homepage = "https://glew.sourceforge.net/";
    license = with lib.licenses; [
      # modified bsd
      free
      mit
      gpl2Only
    ]; # For full details, see https://github.com/nigels-com/glew#copyright-and-licensing
    pkgConfigModules = [ "glew" ];
    platforms =
      if enableEGL then
        lib.subtractLists lib.platforms.darwin mesa.meta.platforms
      else
        mesa.meta.platforms;
    hasNoMaintainersButDependents = true;
  };
})
