{
  lib,
  stdenv,
  gcc14Stdenv,
  fetchFromGitHub,
  cmake,
  libpq,
  postgresql,
  postgresqlTestHook,
  testers,
}:

# Work around issue reported in https://github.com/NixOS/nixpkgs/issues/476278.
# Should be solved when libpqxx 8.x is released.
(if stdenv.cc.isGNU then gcc14Stdenv else stdenv).mkDerivation (finalAttrs: {
  pname = "libpqxx";
  version = "7.10.7";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = "libpqxx";
    rev = finalAttrs.version;
    hash = "sha256-A33Z6xSIReYHHS3KerBSDTuo59tixduxXVEMfa/2I7A=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libpq ];

  nativeCheckInputs = [
    postgresql
    postgresqlTestHook
  ];

  cmakeFlags = [
    (lib.strings.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  postInstall = ''
    # cmake somehow messes up that file so make it manually
    substitute $src/libpqxx.pc.in $out/lib/pkgconfig/libpqxx.pc \
      --subst-var-by prefix ${placeholder "out"} \
      --subst-var-by exec_prefix "''${prefix}" \
      --subst-var-by libdir ${placeholder "out"}/lib \
      --subst-var-by includedir ${placeholder "dev"}/include \
      --subst-var-by VERSION ${finalAttrs.version}
  '';

  checkPhase = ''
    runHook preCheck
    test/runner
    runHook postCheck
  '';

  doCheck = lib.meta.availableOn stdenv.hostPlatform postgresqlTestHook;

  __structuredAttrs = true;

  strictDeps = true;

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
    cmake-config = testers.hasCmakeConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "libpqxx" ];
    };
  };

  meta = {
    changelog = "https://github.com/jtv/libpqxx/releases/tag/${finalAttrs.version}";
    description = "C++ library to access PostgreSQL databases";
    downloadPage = "https://github.com/jtv/libpqxx";
    homepage = "https://pqxx.org/development/libpqxx/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    pkgConfigModules = [ "libpqxx" ];
    platforms = lib.platforms.unix;
  };
})
