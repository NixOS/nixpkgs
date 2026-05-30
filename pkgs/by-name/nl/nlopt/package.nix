{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  nix-update-script,
  # Optionally build Python bindings
  withPython ? false,
  python3,
  python3Packages,
  # Optionally build Octave bindings
  withOctave ? false,
  octave,
  # Optionally build Java bindings
  withJava ? false,
  jdk,
  # Required for building the Python and Java bindings
  swig,
  # Optionally exclude Luksan solvers to allow licensing under MIT
  withoutLuksanSolvers ? false,

  # Builds docs on-demand
  withDocs ? false,

  # Build static on-demand
  withStatic ? stdenv.hostPlatform.isStatic,

  # v2.8.0 introduced a regression where testing on Linux platforms fails with a buffer overflow
  # when compiled with -D_FORTIFY_SOURCE=3.
  # This was deemed to be a compiler false positive by the library's author in https://github.com/stevengj/nlopt/issues/563.
  # Building with `clangStdenv` prevents this from occurring.
  clangStdenv,
}:
let
  buildPythonBindingsEnv = python3.withPackages (p: [ p.numpy ]);
  buildDocsEnv = python3.withPackages (p: [
    p.mkdocs
    p.python-markdown-math
  ]);
in
clangStdenv.mkDerivation (finalAttrs: {
  pname = "nlopt";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "stevengj";
    repo = "nlopt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i+Cd2VLMbI4PUSXennR8jgF+/ZkzKX9WkVTPtayr8vs=";
  };

  outputs = [ "out" ] ++ lib.optional withDocs "doc";

  postPatch = ''
    substituteInPlace nlopt.pc.in \
      --replace-fail 'libdir=''${exec_prefix}/@NLOPT_INSTALL_LIBDIR@' 'libdir=@NLOPT_INSTALL_LIBDIR@'
  '';

  nativeBuildInputs = [
    cmake
  ]
  ## Building the python bindings requires SWIG, and numpy in addition to the CXX routines.
  ## The tests also make use of the same interpreter to test the bindings.
  ++ lib.optionals withPython [
    swig
    buildPythonBindingsEnv
  ]
  ## Building the java bindings requires SWIG, C++, JNI and Java
  ++ lib.optionals withJava [
    swig
    jdk
  ]
  ## Building octave bindings requires `mkoctfile` to be installed.
  ++ lib.optional withOctave octave;

  # Python bindings depend on numpy at import time.
  propagatedBuildInputs = lib.optional withPython python3Packages.numpy;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!withStatic))
    (lib.cmakeBool "NLOPT_CXX" true)
    (lib.cmakeBool "NLOPT_PYTHON" withPython)
    (lib.cmakeBool "NLOPT_OCTAVE" withOctave)
    (lib.cmakeBool "NLOPT_JAVA" withJava)
    (lib.cmakeBool "NLOPT_SWIG" (withPython || withJava))
    (lib.cmakeBool "NLOPT_FORTRAN" false)
    (lib.cmakeBool "NLOPT_MATLAB" false)
    (lib.cmakeBool "NLOPT_GUILE" false)
    (lib.cmakeBool "NLOPT_LUKSAN" (!withoutLuksanSolvers))
    (lib.cmakeBool "NLOPT_TESTS" finalAttrs.doCheck)
  ]
  ++ lib.optional withPython (
    lib.cmakeFeature "Python_EXECUTABLE" "${buildPythonBindingsEnv.interpreter}"
  );

  postBuild = lib.optionalString withDocs ''
    ${buildDocsEnv.interpreter} -m mkdocs build \
      --config-file ../mkdocs.yml \
      --site-dir $doc \
      --no-directory-urls
  '';

  doCheck = true;

  postFixup = ''
    substituteInPlace $out/lib/cmake/nlopt/NLoptLibraryDepends.cmake --replace-fail \
      'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/' 'INTERFACE_INCLUDE_DIRECTORIES "'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://nlopt.readthedocs.io/en/latest/";
    changelog = "https://github.com/stevengj/nlopt/releases/tag/v${finalAttrs.version}";
    description = "Free open-source library for nonlinear optimization";
    license = if withoutLuksanSolvers then lib.licenses.mit else lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.bengsparks ];
  };
})
