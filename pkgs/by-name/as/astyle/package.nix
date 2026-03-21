{
  stdenv,
  lib,
  fetchurl,
  cmake,
  versionCheckHook,
  asLibrary ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "astyle";
  version = "3.6.14";

  src = fetchurl {
    url = "mirror://sourceforge/astyle/astyle-${finalAttrs.version}.tar.bz2";
    hash = "sha256-HEb9wiy+mcYDWTmTt1C6pMouC0yeSx2Q4vtg10nWCNA=";
  };

  nativeBuildInputs = [ cmake ];

  # upstream repo includes a build/ directory
  cmakeBuildDir = "_build";

  cmakeFlags = lib.optional asLibrary [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  postInstall = lib.optionalString asLibrary ''
    install -Dm444 ../src/astyle.h $out/include/astyle.h
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = !asLibrary;

  meta = {
    description = "Source code indenter, formatter, and beautifier for C, C++, C# and Java";
    mainProgram = "astyle";
    homepage = "https://astyle.sourceforge.net/";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ carlossless ];
    platforms = lib.platforms.unix;
  };
})
