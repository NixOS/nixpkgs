{
  lib,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  stdenv,
  testers,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quickjs-ng";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "quickjs-ng";
    repo = "quickjs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Mb0YyxTWU6a8HFTVBmlJ5yGEDmjKXHqTSszAvb8Y01U=";
  };

  patches = [
    # CVE-2026-1145: Fix heap buffer overflow in js_typed_array_constructor_ta
    # https://github.com/quickjs-ng/quickjs/issues/1305
    (fetchpatch {
      name = "CVE-2026-1145.patch";
      url = "https://github.com/quickjs-ng/quickjs/commit/53aebe66170d545bb6265906fe4324e4477de8b4.patch";
      hash = "sha256-PObMEqIush07mQ7YcoFUJ3rXitOlEU0tCsgVi6P2zW0=";
    })
    # CVE-2026-1144: Fix OOB access in atomic ops
    # https://github.com/quickjs-ng/quickjs/issues/1301
    # https://github.com/quickjs-ng/quickjs/issues/1302
    (fetchpatch {
      name = "CVE-2026-1144.patch";
      url = "https://github.com/quickjs-ng/quickjs/commit/ea3e9d77454e8fc9cb3ef3c504e9c16af5a80141.patch";
      hash = "sha256-ph6U+Mz7gxR4RWEtc+XU5fO6qjApQTqqW5dzwnOqTdc=";
    })
  ];

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

  strictDeps = true;

  postBuild = ''
    pushd ../docs
    makeinfo *texi
    popd
  '';

  postInstall = ''
    pushd ../docs
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
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
