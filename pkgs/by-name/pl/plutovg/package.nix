{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "plutovg";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "sammycage";
    repo = "plutovg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-989MA60nc1Tzp/4RzT0iYHz4JBJkU9zgEjEswa4vDpk=";
  };

  cmakeFlags = [
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    homepage = "https://github.com/sammycage/plutovg/";
    changelog = "https://github.com/sammycage/plutovg/releases/tag/v${finalAttrs.version}";
    description = "Tiny 2D vector graphics library in C";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.eymeric ];
  };
})
