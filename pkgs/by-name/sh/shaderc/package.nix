{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  versionCheckHook,
  cmake,
  python3,
  darwin,
  cctools,
  glslang,
  spirv-tools,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "shaderc";
  version = "2026.1";

  outputs = [
    "out"
    "lib"
    "bin"
    "dev"
    "static"
  ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "shaderc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OiBv18zxeE/gqY4zOMXTsCdkAEWo9BIehdu/adw0+cE=";
  };

  patches = [
    (replaceVars ./unvendor-glslang.patch {
      shaderc-version = finalAttrs.version;
      spirv-tools-version = spirv-tools.version;
      glslang-version = glslang.version;
    })

    # https://github.com/google/shaderc/pull/1529
    ./fix-pc-file-generation.patch
  ];

  postPatch = ''
    patchShebangs --build utils/
  '';

  nativeBuildInputs = [
    cmake
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    darwin.autoSignDarwinBinariesHook
  ];

  propagatedBuildInputs = [
    glslang
  ];

  postInstall = ''
    moveToOutput "lib/*.a" $static
  '';

  cmakeFlags = [ "-DSHADERC_SKIP_TESTS=ON" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
    # The version in pc files has `.1` appended to indicate that it's not a dev version
    versionCheck = false;
  };

  meta = {
    description = "Collection of tools, libraries and tests for shader compilation";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    mainProgram = "glslc";
    pkgConfigModules = [
      "shaderc_combined"
      "shaderc"
      "shaderc_static"
    ];
  };
})
