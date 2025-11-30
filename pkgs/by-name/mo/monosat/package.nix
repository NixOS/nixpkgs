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
  boolToCmake = x: if x then "ON" else "OFF";

  rev = "1.8.0";
  sha256 = "0q3a8x3iih25xkp2bm842sm2hxlb8hxlls4qmvj7vzwrh4lvsl7b";

  pname = "monosat";
  version = rev;

  src = fetchFromGitHub {
    owner = "sambayless";
    repo = "monosat";
    inherit rev sha256;
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
      --replace 'defined(__linux__)' '0'
  '';

  core = stdenv.mkDerivation {
    name = "${pname}-${version}";
    inherit src patches;
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
      "-DBUILD_STATIC=OFF"
      "-DJAVA=${boolToCmake includeJava}"
      "-DGPL=${boolToCmake includeGplCode}"

      # file RPATH_CHANGE could not write new RPATH
      "-DCMAKE_SKIP_BUILD_RPATH=ON"
    ];

    postInstall = lib.optionalString includeJava ''
      mkdir -p $out/share/java
      cp monosat.jar $out/share/java
    '';

    passthru = { inherit python; };

    meta = with lib; {
      description = "SMT solver for Monotonic Theories";
      mainProgram = "monosat";
      platforms = platforms.unix;
      license = if includeGplCode then licenses.gpl2 else licenses.mit;
      homepage = "https://github.com/sambayless/monosat";
      maintainers = [ maintainers.acairncross ];
    };
  };

  python =
    {
      buildPythonPackage,
      cython,
      pytestCheckHook,
    }:
    buildPythonPackage {
      format = "setuptools";
      inherit
        pname
        version
        src
        patches
        ;

      propagatedBuildInputs = [
        core
        cython
      ];

      # This tells setup.py to use cython, which should produce faster bindings
      MONOSAT_CYTHON = true;

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
              --replace 'library_dir = "../../../../"' 'library_dir = "${core}/lib/"'
          '';

      nativeCheckInputs = [ pytestCheckHook ];

      disabledTests = [
        "test_assertAtMostOne"
        "test_assertEqual"
      ];
    };
in
core
