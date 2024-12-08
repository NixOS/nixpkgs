{
  build2,
  fetchgit,
  gccStdenv,
  lib,
  xercesc,
}:

gccStdenv.mkDerivation (finalAttrs: {
  pname = "libcutl";
  version = "1.11.0";

  src = fetchgit {
    url = "https://git.codesynthesis.com/libcutl/libcutl.git";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-LY2ZyxduI6xftVjVqjNkhYPFTL5bvHC289Qcei1Kiw4=";
  };

  nativeBuildInputs = [ build2 ];

  buildInputs = [ xercesc ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    description = "C++ utility library from Code Synthesis";
    longDescription = ''
      libcutl is a C++ utility library.
      It contains a collection of generic and independent components such as
      meta-programming tests, smart pointers, containers, compiler building blocks, etc.
    '';
    homepage = "https://codesynthesis.com/projects/libcutl/";
    changelog = "https://git.codesynthesis.com/cgit/libcutl/libcutl/log/";
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.xzfc ];
    license = lib.licenses.mit;
  };
})
