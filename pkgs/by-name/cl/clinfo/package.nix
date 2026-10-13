{
  lib,
  stdenv,
  fetchFromGitHub,
  ocl-icd,
  opencl-headers,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clinfo";
  version = "3.1.26.09.26";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Oblomov";
    repo = "clinfo";
    tag = finalAttrs.version;
    hash = "sha256-5lM/6ULfw0xwXOZU2Kvc2h1oY7JBCvbAFuVn8mRvRX8=";
  };

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    ocl-icd
    opencl-headers
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Print all known information about all available OpenCL platforms and devices in the system";
    homepage = "https://github.com/Oblomov/clinfo";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [
      athas
      r-burns
    ];
    platforms = lib.platforms.unix;
    mainProgram = "clinfo";
  };
})
