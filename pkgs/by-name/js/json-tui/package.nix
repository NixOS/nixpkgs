{
  lib,
  stdenv,
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
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "json-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PXiTlTwF/qL/Nq1PSf8PHgKa0MD6QrA0tSWiFfm93Gk=";
  };

  strictDeps = true;

  buildInputs = [
    ftxui
    libargs
    nlohmann_json
  ];

  nativeBuildInputs = [ cmake ];

  checkInputs = [ gbenchmark ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  env.NIX_CFLAGS_COMPILE = "-fexceptions";

  cmakeFlags = [
    "-Wno-dev" # suppress cmake warning about deprecated usage
    (lib.cmakeBool "JSON_TUI_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
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
