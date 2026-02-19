{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  cmake,
  zlib,
  gmp,
  jdk8,
  # The JDK we use on Darwin currently makes extensive use of rpaths which are
  # annoying and break the python library, so let's not bother for now
  includeJava ? !stdenv.hostPlatform.isDarwin,
  includeGplCode ? true,
}:

let
  pname = "monosat";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "sambayless";
    repo = "monosat";
    tag = version;
    sha256 = "0q3a8x3iih25xkp2bm842sm2hxlb8hxlls4qmvj7vzwrh4lvsl7b";
  };

  patches = [
    # Python 3.8 compatibility
    (fetchpatch {
      url = "https://github.com/sambayless/monosat/commit/a5079711d0df0451f9840f3a41248e56dbb03967.patch";
      sha256 = "1p2y0jw8hb9c90nbffhn86k1dxd6f6hk5v70dfmpzka3y6g1ksal";
    })
  ];

  # source behind __linux__ check assumes system is also x86 and
  # tries to disable x86/x87-specific extended precision mode
  # https://github.com/sambayless/monosat/issues/33
  commonPostPatch = lib.optionalString (!stdenv.hostPlatform.isx86) ''
    substituteInPlace src/monosat/Main.cc \
      --replace-fail 'defined(__linux__)' '0'
  '';

  core = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      patches
      ;
    postPatch = commonPostPatch + ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "cmake_minimum_required(VERSION 3.02)" "cmake_minimum_required(VERSION 3.10)"
    '';
    nativeBuildInputs = [ cmake ];
    buildInputs = [
      zlib
      gmp
      jdk8
    ];

    cmakeFlags = [
      (lib.cmakeBool "BUILD_STATIC" false)
      (lib.cmakeBool "JAVA" includeJava)
      (lib.cmakeBool "GPL" includeGplCode)
      # file RPATH_CHANGE could not write new RPATH
      (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
    ];

    postInstall = lib.optionalString includeJava ''
      mkdir -p $out/share/java
      cp monosat.jar $out/share/java
    '';

    passthru = { inherit python; };

    meta = {
      description = "SMT solver for Monotonic Theories";
      mainProgram = "monosat";
      platforms = lib.platforms.unix;
      license = if includeGplCode then lib.licenses.gpl2 else lib.licenses.mit;
      homepage = "https://github.com/sambayless/monosat";
      maintainers = [ lib.maintainers.acairncross ];
    };
  };

  python =
    {
      buildPythonPackage,
      setuptools,
      cython,
      pytestCheckHook,
    }:
    buildPythonPackage {
      pyproject = true;

      inherit
        pname
        version
        src
        patches
        ;

      build-system = [
        setuptools
        cython
      ];

      buildInputs = [ core ];

      # This tells setup.py to use cython, which should produce faster bindings
      env.MONOSAT_CYTHON = true;

      # After patching src, move to where the actually relevant source is. This could just be made
      # the sourceRoot if it weren't for the patch.
      postPatch =
        commonPostPatch
        + ''
          cd src/monosat/api/python
        ''
        +
          # The relative paths here don't make sense for our Nix build
          # TODO: do we want to just reference the core monosat library rather than copying the
          # shared lib? The current setup.py copies the .dylib/.so...
          ''
            substituteInPlace setup.py \
              --replace-fail 'library_dir = "../../../../"' 'library_dir = "${core}/lib/"'
          '';

      nativeCheckInputs = [ pytestCheckHook ];

      disabledTests = [
        "test_assertAtMostOne"
        "test_assertEqual"
      ];

      pythonImportsCheck = [
        "monosat"
        "monosat.monosat_p"
      ];
    };
in
core
