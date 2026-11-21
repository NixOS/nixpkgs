{
  lib,
  stdenv,
  fetchFromGitHub,
  substitute,
  cmake,
  ninja,
  openssl,
  qt6,
  qt6Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openuaexplorer";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "sanny32";
    repo = "OpenUaExplorer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HITDkLZzOmARwVSef6B3pP6HwYZ1nf8nK23hycjOZ38=";
  };

  cmakeDir = "../src";

  strictDeps = true;
  __structuredAttrs = true;

  postPatch = ''
    # Nix links against its own libstdc++; no need for a portable binary.
    substituteInPlace src/cmake/target_linux.cmake \
      --replace-fail "-static-libgcc -static-libstdc++" ""

    # An installed Qt 6 QtKeychain puts its headers under qt6keychain/;
    # the qtkeychain/ path only exists in upstream's FetchContent build tree.
    substituteInPlace src/core/opcua/secretstore.cpp \
      --replace-fail "<qtkeychain/keychain.h>" "<qt6keychain/keychain.h>"

    # Git is only used to fetch and patch Qt OPC UA, which is provided here.
    substituteInPlace src/cmake/qtopcua.cmake \
      --replace-fail "find_package(Git REQUIRED)" "find_package(Git QUIET)"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    qt6.qttools # lrelease (LinguistTools)
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtcharts
    qt6.qtwayland
    qt6Packages.qtkeychain
    openssl
    finalAttrs.passthru.qtopcua
  ];

  cmakeFlags = [
    # Never let CMake try to download anything.
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
    "-DOUAEXP_FETCH_QTKEYCHAIN=OFF"
    "-DUSE_QLEMENTINE_APP_STYLE=OFF"
    "-DOUAEXP_BUILD_TESTS=OFF"
  ];

  passthru = {
    # Upstream builds Qt OPC UA with its own fixes to the open62541 backend
    # (src/cmake/patches); the app needs the session name API from 0004.
    qtopcua = qt6.qtopcua.overrideAttrs (old: {
      patches = old.patches or [ ] ++ [
        "${finalAttrs.src}/src/cmake/patches/0001-open62541-no-keepalive-read-without-a-session.patch"
        "${finalAttrs.src}/src/cmake/patches/0002-open62541-plugin-null-dataencoding-on-historyread.patch"
        "${finalAttrs.src}/src/cmake/patches/0003-open62541-plugin-certificate-errors-are-trust-decisions.patch"
        # The last hunk's header undercounts its lines (6/13 instead of 8/15).
        # `git apply`, which upstream uses, tolerates that; GNU patch does not.
        (substitute {
          src = "${finalAttrs.src}/src/cmake/patches/0004-open62541-plugin-send-a-session-name.patch";
          substitutions = [
            "--replace-fail"
            "@@ -1230,6 +1230,13 @@"
            "@@ -1230,8 +1230,15 @@"
          ];
        })
        "${finalAttrs.src}/src/cmake/patches/0005-open62541-plugin-quiet-empty-pki-directories.patch"
        "${finalAttrs.src}/src/cmake/patches/0006-open62541-plugin-quiet-the-duplicate-connect-warning.patch"
      ];
    });
  };

  meta = {
    description = "Open source OPC UA client for browsing, inspecting and monitoring OPC UA servers";
    homepage = "https://github.com/sanny32/OpenUaExplorer";
    changelog = "https://github.com/sanny32/OpenUaExplorer/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "ouaexp";
    maintainers = with lib.maintainers; [ dasj19 ];
    platforms = lib.platforms.linux;
  };
})
