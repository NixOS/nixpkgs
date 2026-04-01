{
  lib,
  stdenv,
  fetchpatch2,
  fetchFromGitHub,

  cmake,
  ftxui,
  libargs,
  nlohmann_json,
  gtest,
  gbenchmark,

  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "json-tui";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "json-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qS2EbCxH8sUUJMu5hwm1+Nu6SsJRfLReX56YSd1RZU4=";
  };

  patches = [
    # fixes tests - https://github.com/ArthurSonzogni/json-tui/pull/37
    (fetchpatch2 {
      url = "https://github.com/ArthurSonzogni/json-tui/commit/645060a016c1e1ca84b9e1dc638a926415aaa5fe.patch?full_index=1";
      hash = "sha256-8AZEZgU8HHyaasb/7LegSwRAMo1iyonv3XUY284nYKg=";
    })
  ];

  strictDeps = true;

  buildInputs = [
    ftxui
    libargs
    nlohmann_json
  ];

  nativeBuildInputs = [ cmake ];

  checkInputs = [ gbenchmark ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  cmakeFlags = [
    "-Wno-dev" # suppress cmake warning about deprecated usage
    (lib.cmakeBool "JSON_TUI_BUILD_TESTS" finalAttrs.doCheck)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GOOGLETEST" "${gtest.src}")
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    homepage = "https://github.com/ArthurSonzogni/json-tui";
    changelog = "https://github.com/ArthurSonzogni/json-tui/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "JSON terminal UI made in C++";
    license = lib.licenses.mit;
    mainProgram = "json-tui";
    maintainers = with lib.maintainers; [ phanirithvij ];
    platforms = lib.platforms.all;
  };
})
