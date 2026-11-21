{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fixDarwinDylibNames,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "capstone";
  version = "5.0.9";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "capstone-engine";
    repo = "capstone";
    tag = finalAttrs.version;
    hash = "sha256-uAiiKWKGjEATPE0Xc3g+aOLCz5ffIlDmf+7jaGwaZ4I=";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ (lib.cmakeBool "CAPSTONE_BUILD_MACOS_THIN" true) ];

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  doCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";
  doInstallCheck = true;

  meta = {
    description = "Advanced disassembly library";
    homepage = "http://www.capstone-engine.org";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      thoughtpolice
      ris
    ];
    mainProgram = "cstool";
    platforms = lib.platforms.unix;
  };
})
