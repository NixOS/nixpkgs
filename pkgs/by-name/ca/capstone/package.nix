{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "capstone";
  version = "5.0.9";

  src = fetchFromGitHub {
    owner = "capstone-engine";
    repo = "capstone";
    rev = finalAttrs.version;
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
