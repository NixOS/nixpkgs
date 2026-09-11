{
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  zlib,
  copyPkgconfigItems,
  makePkgconfigItem,
  lib,
  testers,
  ctestCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kaitai-struct-cpp-stl-runtime";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "kaitai-io";
    repo = "kaitai_struct_cpp_stl_runtime";
    tag = finalAttrs.version;
    sha256 = "sha256-2glGPf08bkzvnkLpQIaG2qiy/yO+bZ14hjIaCKou2vU=";
  };

  doCheck = true;

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    copyPkgconfigItems
    ctestCheckHook
  ];

  buildInputs = [
    zlib
    gtest
  ];

  strictDeps = true;

  # https://github.com/kaitai-io/kaitai_struct_cpp_stl_runtime/issues/82
  pkgconfigItems = [
    (makePkgconfigItem rec {
      name = "kaitai-struct-cpp-stl-runtime";
      inherit (finalAttrs) version;
      cflags = [ "-I${variables.includedir}" ];
      libs = [
        "-L${variables.libdir}"
        "-lkaitai_struct_cpp_stl_runtime"
      ];
      variables = {
        includedir = "${placeholder "dev"}/include";
        libdir = "${placeholder "out"}/lib";
      };
      inherit (finalAttrs.meta) description;
    })
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    pkgConfigModules = [ "kaitai-struct-cpp-stl-runtime" ];
    description = "Kaitai Struct C++ STL Runtime Library";
    homepage = "https://github.com/kaitai-io/kaitai_struct_cpp_stl_runtime";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fzakaria ];
  };
})
