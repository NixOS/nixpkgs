{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  python3,
  validatePkgConfig,
  versionCheckHook,
  testers,
  nix-update-script,

  enableCmdline ? !stdenv.hostPlatform.isNone,
  enableMath ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "jerryscript";
  version = "3.0.0";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "jerryscript-project";
    repo = "jerryscript";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Evu4qLlwg3Sf9w/ojtZMNxGJEtopHgKnwqlpf115zD4=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    (lib.cmakeBool "JERRY_CMDLINE" enableCmdline)
    (lib.cmakeBool "JERRY_MATH" enableMath)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  nativeCheckInputs = [
    python3
  ];
  doCheck = true;
  checkPhase = ''
    runHook preCheck

    pushd ../
    python3 tools/run-tests.py --unittests
    popd

    runHook postCheck
  '';

  # Uses a custom lib variable that ignores what nixpkgs's cmake setupHook specifies.
  postInstall = ''
    mkdir -p "$lib/lib"
    mv "$out/lib/"*.so "$lib/lib"
  '';

  nativeInstallCheckInputs = [
    validatePkgConfig
    versionCheckHook
  ];
  doInstallCheck = true;
  postInstallCheck = ''
    echo 'print("Hello" + " " + "World!")' | \
    "$out/bin/jerry" - | \
    cmp - <(echo "Hello World!")
  '';

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Lightweight JavaScript engine for resource-constrained devices";
    homepage = "https://jerryscript.net/";
    downloadPage = "https://github.com/jerryscript-project/jerryscript/";
    changelog = "https://github.com/jerryscript-project/jerryscript/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "jerry";
    pkgConfigModules = [
      "libjerry-core"
      "libjerry-ext"
      "libjerry-port"
    ];
    maintainers = with lib.maintainers; [ RossSmyth ];
  };
})
