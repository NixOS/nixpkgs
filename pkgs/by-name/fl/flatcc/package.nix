{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flatcc";
  version = "0.6.1";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "dvidelabs";
    repo = "flatcc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0/IZ7eX6b4PTnlSSdoOH0FsORGK9hrLr1zlr/IHsJFQ=";
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
  ]
  ++ lib.optionals stdenv.cc.isClang [
    # Fix clang compilation
    # https://github.com/dvidelabs/flatcc/pull/273
    (fetchpatch {
      name = "fix-c23-fallthrough.patch";
      url = "https://github.com/dvidelabs/flatcc/commit/7c199e3b191a6f714694035f1eba40112e71675c.patch";
      hash = "sha256-kGupiMVa2r+hsQnknatRK+EfscNjJD0T75NY1ELkJ5U=";
    })

    # Fix implicit int conversion on negation for int8/int16
    # https://github.com/dvidelabs/flatcc/commit/5df663837c93eb7516890c27574dcc4b042890cb
    (fetchpatch {
      name = "fix-pprintint-implicit-int-conversion.patch";
      url = "https://github.com/dvidelabs/flatcc/commit/5df663837c93eb7516890c27574dcc4b042890cb.patch";
      hash = "sha256-pntpatUDkZbj5pEViA8jDvXP+9KNdfhUDQCUd598Lxg=";
      excludes = [ "CHANGELOG.md" ];
    })
  ];

  postPatch = ''
    substituteInPlace include/flatcc/portable/grisu3_print.h \
      --replace-fail \
        'static char hexdigits[16] = "0123456789ABCDEF";' \
        "static char hexdigits[16] = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};"
  '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "FLATCC_INSTALL" true)
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "FlatBuffers Compiler and Library in C for C";
    mainProgram = "flatcc";
    homepage = "https://github.com/dvidelabs/flatcc";
    changelog = "https://github.com/dvidelabs/flatcc/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = [ lib.licenses.asl20 ];
    maintainers = with lib.maintainers; [ onny ];
  };
})
