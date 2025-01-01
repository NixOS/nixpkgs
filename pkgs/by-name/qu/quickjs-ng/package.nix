{ lib
, stdenv
, cmake
, fetchFromGitHub
, testers
, texinfo
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quickjs-ng";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "quickjs-ng";
    repo = "quickjs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gULpJhOOmhzq2Ydl4soNBiiONtdt2T4sgcSqIBCo3SM=";
  };

  outputs = [ "bin" "out" "dev" "doc" "info" ];

  nativeBuildInputs = [
    cmake
    texinfo
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    (lib.cmakeBool "BUILD_STATIC_QJS_EXE" stdenv.hostPlatform.isStatic)
  ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    "-Wno-error=stringop-overflow"
  ]);

  postInstall = ''
    (cd ../doc
     makeinfo --output quickjs.info quickjs.texi
     install -Dt $info/share/info/ quickjs.info)
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "qjs --help || true";
    };
  };

  meta = with lib; {
    description = "Mighty JavaScript engine";
    homepage = "https://github.com/quickjs-ng/quickjs";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
    mainProgram = "qjs";
  };
})
