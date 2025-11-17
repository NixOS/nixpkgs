{
  buildPackages,
  cmake,
  fetchFromGitHub,
  lib,
  ninja,
  stdenv,
  versionCheckHook,
}:

let
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "quick-lint";
    repo = "quick-lint-js";
    tag = version;
    hash = "sha256-L2LCRm1Fsg+xRdPc8YmgxDnuXJo92nxs862ewzObZ3I=";
  };

  cmakeFlags = [
    (lib.cmakeBool "QUICK_LINT_JS_ENABLE_BUILD_TOOLS" true)

    # Temporary workaround for https://github.com/NixOS/nixpkgs/pull/108496#issuecomment-1192083379
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)

    # CMake 4 dropped support of versions lower than 3.5,
    # versions lower than 3.10 are deprecated.
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10")
  ];

  quick-lint-js-build-tools = buildPackages.stdenv.mkDerivation {
    pname = "quick-lint-js-build-tools";
    inherit version src;

    nativeBuildInputs = [
      cmake
      ninja
    ];
    inherit cmakeFlags;
    ninjaFlags = "quick-lint-js-build-tools";

    installPhase = ''
      runHook preInstall
      cmake --install . --component build-tools
      runHook postInstall
    '';

    doCheck = false;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "quick-lint-js";
  inherit version src;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  inherit cmakeFlags;

  doCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    # Expose quick-lint-js-build-tools to nix repl as quick-lint-js.build-tools.
    build-tools = quick-lint-js-build-tools;
  };

  meta = {
    description = "Find bugs in Javascript programs";
    mainProgram = "quick-lint-js";
    homepage = "https://quick-lint-js.com";
    downloadPage = "https://github.com/quick-lint/quick-lint-js";
    changelog = "https://github.com/quick-lint/quick-lint-js/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ratsclub ];
    platforms = lib.platforms.all;
  };
})
