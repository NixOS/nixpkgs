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
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "shaderc";
  version = "2025.5";

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
    hash = "sha256-PmGRZDXblrBhZe16QfpHfRdsRhXnGsN7o+qh14nlOUQ=";
  };

  patches = [
    (replaceVars ./unvendor-glslang.patch {
      shaderc-version = finalAttrs.version;
      spirv-tools-version = spirv-tools.version;
      glslang-version = glslang.version;
    })
  ];

  postPatch = ''
    patchShebangs --build utils/

    substituteInPlace cmake/*.pc.in \
      --replace-fail $'{prefix}/@CMAKE_INSTALL_' '@CMAKE_INSTALL_FULL_'
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

  meta = {
    description = "Collection of tools, libraries and tests for shader compilation";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    mainProgram = "glslc";
  };
})
