{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "flatcc";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "dvidelabs";
    repo = "flatcc";
    rev = "v${version}";
    sha256 = "sha256-0/IZ7eX6b4PTnlSSdoOH0FsORGK9hrLr1zlr/IHsJFQ=";
  };

  patches = [
    # Fix builds on clang15. Remove post-0.6.1.
    (fetchpatch {
      name = "clang15fixes.patch";
      url = "https://github.com/dvidelabs/flatcc/commit/5885e50f88248bc7ed398880c887ab23db89f05a.patch";
      hash = "sha256-z2HSxNXerDFKtMGu6/vnzGRlqfz476bFMjg4DVfbObQ";
    })
    # Bump cmake to 2.8.12, required fox 3.16 patch
    (fetchpatch {
      name = "bump-cmake-version.patch";
      url = "https://github.com/dvidelabs/flatcc/commit/5f07eda43caabd81a2bfa2857af0e3f26dc6d4ee.patch?full_index=1";
      hash = "sha256-eRlkQw+YGRgCUjrlYB3I8w+/cPuJhgEfNUW/+TZhHlI=";
    })
    # Bump min. CMake to 3.16 and fix custom build rules
    (fetchpatch {
      name = "fix-cmake-version.patch";
      url = "https://github.com/dvidelabs/flatcc/commit/385c27b23236dff7ad4fa35c59fd4f9143dcaae6.patch?full_index=1";
      hash = "sha256-ORDby2LRRQdFrNc1owHKxo0TfMIxISj5SuD5oqvDFFo=";
      excludes = [
        "README.md"
        "CHANGELOG.md"
        "test/doublevec_test/CMakeLists.txt"
        "test/monster_test_cpp/CMakeLists.txt"
      ];
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DFLATCC_INSTALL=on"
  ];

  meta = with lib; {
    description = "FlatBuffers Compiler and Library in C for C";
    mainProgram = "flatcc";
    homepage = "https://github.com/dvidelabs/flatcc";
    license = [ licenses.asl20 ];
    maintainers = with maintainers; [ onny ];
  };
}
