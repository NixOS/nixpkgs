{
  lib,
  cmake,
  fetchFromGitHub,
  stdenv,
  testers,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quickjs-ng";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "quickjs-ng";
    repo = "quickjs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7IAkmlzgiPVd8yRv7LU5a7HWCB+eQk1Ur1KwZupwty0=";
  };

  outputs = [
    "out"
    "bin"
    "dev"
    "doc"
    "info"
  ];

  nativeBuildInputs = [
    cmake
    texinfo
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "BUILD_STATIC_QJS_EXE" stdenv.hostPlatform.isStatic)
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      "-Wno-error=stringop-overflow"
    ]
  );

  strictDeps = true;

  postBuild = ''
    pushd ../doc
    makeinfo *texi
    popd
  '';

  postInstall = ''
    pushd ../doc
    install -Dm644 -t ''${!outputInfo}/share/info *info
    popd
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "qjs --help || true";
    };
  };

  meta = {
    homepage = "https://github.com/quickjs-ng/quickjs";
    description = "Mighty JavaScript engine";
    license = lib.licenses.mit;
    mainProgram = "qjs";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
})
