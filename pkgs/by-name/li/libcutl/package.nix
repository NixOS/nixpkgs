{
  fetchurl,
  gccStdenv,
  lib,
  xercesc,
}:

gccStdenv.mkDerivation (finalAttrs: {
  pname = "libcutl";
  version = "1.10.0";

  src = fetchurl {
    url = "https://codesynthesis.com/download/libcutl/${lib.versions.majorMinor finalAttrs.version}/libcutl-${finalAttrs.version}.tar.bz2";
    hash = "sha256-ElFjxnDjcrR9VibVQ3n/j7re1szV23esC/WRKkAXEhw=";
  };

  buildInputs = [ xercesc ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = toString [ "-std=c++14" ];

  meta = {
    description = "C++ utility library from Code Synthesis";
    longDescription = ''
      libcutl is a C++ utility library.
      It contains a collection of generic and independent components such as
      meta-programming tests, smart pointers, containers, compiler building blocks, etc.
    '';
    homepage = "https://codesynthesis.com/projects/libcutl/";
    changelog = "https://git.codesynthesis.com/cgit/libcutl/libcutl/plain/NEWS?h=${finalAttrs.version}";
    platforms = lib.platforms.all;
    maintainers = [ ];
    license = lib.licenses.mit;
  };
})
