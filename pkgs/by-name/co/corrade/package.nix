{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ctestCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corrade";
  version = "2020.06-unstable-2026-11-13";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "mosra";
    repo = "corrade";
    rev = "dd288e0ad9d8c12f2ec233c41c0368e99fc57628";
    hash = "sha256-0EjDapOETSHGiEePA574v5YQQq5zXkIuUjyXMT3aB3M=";
  };

  nativeBuildInputs = [ cmake ];
  nativeCheckInputs = [ ctestCheckHook ];

  cmakeFlags = [
    (lib.cmakeBool "CORRADE_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;
  postPatch = ''
    # Helper function to skip tests in the root-privileged Nix sandbox
    skip_test() {
      substituteInPlace "$1" \
        --replace-fail "void $2() {" "void $2() { CORRADE_SKIP(\"Skipped in Nix sandbox\");"
    }

    skip_test src/Corrade/Utility/Test/DirectoryTest.cpp DirectoryTest::mapWriteNoPermission
    skip_test src/Corrade/Utility/Test/DirectoryTest.cpp DirectoryTest::copyWriteNoPermission
    skip_test src/Corrade/Utility/Test/DirectoryTest.cpp DirectoryTest::writeNoPermission
    skip_test src/Corrade/Utility/Test/DirectoryTest.cpp DirectoryTest::appendNoPermission
    skip_test src/Corrade/Utility/Test/DirectoryTest.cpp DirectoryTest::mkpathNoPermission
    skip_test src/Corrade/Utility/Test/DirectoryTest.cpp DirectoryTest::moveDestinationNoPermission
    skip_test src/Corrade/Utility/Test/DirectoryTest.cpp DirectoryTest::configurationDir
    skip_test src/Corrade/Utility/Test/DirectoryTest.cpp DirectoryTest::home
    skip_test src/Corrade/Utility/Test/PathTest.cpp PathTest::mapWriteNoPermission
    skip_test src/Corrade/Utility/Test/PathTest.cpp PathTest::copyWriteNoPermission
    skip_test src/Corrade/Utility/Test/PathTest.cpp PathTest::writeNoPermission
    skip_test src/Corrade/Utility/Test/PathTest.cpp PathTest::appendNoPermission
    skip_test src/Corrade/Utility/Test/PathTest.cpp PathTest::configurationDirectory
    skip_test src/Corrade/Utility/Test/PathTest.cpp PathTest::moveDestinationNoPermission
    skip_test src/Corrade/Utility/Test/PathTest.cpp PathTest::makeNoPermission
    skip_test src/Corrade/Utility/Test/PathTest.cpp PathTest::homeDirectory
    skip_test src/Corrade/PluginManager/Test/ManagerTest.cpp ManagerTest::pluginDirectoryNotReadable
  '';

  meta = {
    description = "C++11 multiplatform utility library";
    homepage = "https://github.com/mosra/corrade";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.arntanguy ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
