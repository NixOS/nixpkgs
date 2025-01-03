{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  python,
  fixDarwinDylibNames,
  javaBindings ? false,
  ocamlBindings ? false,
  pythonBindings ? true,
  jdk ? null,
  ocaml ? null,
  findlib ? null,
  zarith ? null,
  writeScript,
  replaceVars,
}:

assert javaBindings -> jdk != null;
assert ocamlBindings -> ocaml != null && findlib != null && zarith != null;

let
  common =
    {
      version,
      sha256,
      patches ? [ ],
      tag ? "z3",
      doCheck ? true,
    }:
    stdenv.mkDerivation rec {
      pname = "z3";
      inherit version sha256 patches;
      src = fetchFromGitHub {
        owner = "Z3Prover";
        repo = "z3";
        rev = "${tag}-${version}";
        sha256 = sha256;
      };

      strictDeps = true;

      nativeBuildInputs =
        [ python ]
        ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames
        ++ lib.optional javaBindings jdk
        ++ lib.optionals ocamlBindings [
          ocaml
          findlib
        ];
      propagatedBuildInputs = [ python.pkgs.setuptools ] ++ lib.optionals ocamlBindings [ zarith ];
      enableParallelBuilding = true;

      postPatch =
        lib.optionalString ocamlBindings ''
          export OCAMLFIND_DESTDIR=$ocaml/lib/ocaml/${ocaml.version}/site-lib
          mkdir -p $OCAMLFIND_DESTDIR/stublibs
        ''
        +
          lib.optionalString
            ((lib.versionAtLeast python.version "3.12") && (lib.versionOlder version "4.8.14"))
            ''
              # See https://github.com/Z3Prover/z3/pull/5729. This is a specialization of this patch for 4.8.5.
              for file in scripts/mk_util.py src/api/python/CMakeLists.txt; do
                substituteInPlace "$file" \
                  --replace-fail "distutils.sysconfig.get_python_lib()" "sysconfig.get_path('purelib')" \
                  --replace-fail "distutils.sysconfig" "sysconfig"
              done
            '';

      configurePhase =
        lib.concatStringsSep " " (
          [ "${python.pythonOnBuildForHost.interpreter} scripts/mk_make.py --prefix=$out" ]
          ++ lib.optional javaBindings "--java"
          ++ lib.optional ocamlBindings "--ml"
          ++ lib.optional pythonBindings "--python --pypkgdir=$out/${python.sitePackages}"
        )
        + "\n"
        + "cd build";

      inherit doCheck;
      checkPhase = ''
        make -j $NIX_BUILD_CORES test
        ./test-z3 -a
      '';

      postInstall =
        ''
          mkdir -p $dev $lib
          mv $out/lib $lib/lib
          mv $out/include $dev/include
        ''
        + lib.optionalString pythonBindings ''
          mkdir -p $python/lib
          mv $lib/lib/python* $python/lib/
          ln -sf $lib/lib/libz3${stdenv.hostPlatform.extensions.sharedLibrary} $python/${python.sitePackages}/z3/lib/libz3${stdenv.hostPlatform.extensions.sharedLibrary}
        ''
        + lib.optionalString javaBindings ''
          mkdir -p $java/share/java
          mv com.microsoft.z3.jar $java/share/java
          moveToOutput "lib/libz3java.${stdenv.hostPlatform.extensions.sharedLibrary}" "$java"
        '';

      doInstallCheck = true;
      installCheckPhase = ''
        $out/bin/z3 -version 2>&1 | grep -F "Z3 version $version"
      '';

      outputs =
        [
          "out"
          "lib"
          "dev"
          "python"
        ]
        ++ lib.optional javaBindings "java"
        ++ lib.optional ocamlBindings "ocaml";

      meta = with lib; {
        description = "High-performance theorem prover and SMT solver";
        mainProgram = "z3";
        homepage = "https://github.com/Z3Prover/z3";
        changelog = "https://github.com/Z3Prover/z3/releases/tag/z3-${version}";
        license = licenses.mit;
        platforms = platforms.unix;
        maintainers = with maintainers; [
          thoughtpolice
          ttuegel
          numinit
        ];
      };
    };

  static-matrix-def-patch = fetchpatch {
    # clang / gcc fixes. fixes typos in some member names
    name = "gcc-15-fixes.patch";
    url = "https://github.com/Z3Prover/z3/commit/2ce89e5f491fa817d02d8fdce8c62798beab258b.patch";
    includes = [ "src/math/lp/static_matrix_def.h" ];
    hash = "sha256-rEH+UzylzyhBdtx65uf8QYj5xwuXOyG6bV/4jgKkXGo=";
  };

  static-matrix-patch = fetchpatch {
    # clang / gcc fixes. fixes typos in some member names
    name = "gcc-15-fixes.patch";
    url = "https://github.com/Z3Prover/z3/commit/2ce89e5f491fa817d02d8fdce8c62798beab258b.patch";
    includes = [ "src/@dir@/lp/static_matrix.h" ];
    stripLen = 3;
    extraPrefix = "src/@dir@/";
    hash = "sha256-+H1/VJPyI0yq4M/61ay8SRCa6OaoJ/5i+I3zVTAPUVo=";
  };

  # replace @dir@ in the path of the given list of patches
  fixupPatches = dir: map (patch: replaceVars patch { dir = dir; });
in
{
  z3_4_13 = common {
    version = "4.13.4";
    sha256 = "sha256-8hWXCr6IuNVKkOegEmWooo5jkdmln9nU7wI8T882BSE=";
  };
  z3_4_12 = common {
    version = "4.12.6";
    sha256 = "sha256-X4wfPWVSswENV0zXJp/5u9SQwGJWocLKJ/CNv57Bt+E=";
    patches =
      fixupPatches "math" [
        ./lower-bound-typo.diff
        static-matrix-patch
      ]
      ++ [
        static-matrix-def-patch
      ];
  };
  z3_4_11 = common {
    version = "4.11.2";
    sha256 = "sha256-OO0wtCvSKwGxnKvu+AfXe4mEzv4nofa7A00BjX+KVjc=";
    patches =
      fixupPatches "math" [
        ./lower-bound-typo.diff
        static-matrix-patch
        ./tail-matrix.diff
      ]
      ++ [
        static-matrix-def-patch
      ];
  };
  z3_4_8 = common {
    version = "4.8.17";
    sha256 = "sha256-BSwjgOU9EgCcm18Zx0P9mnoPc9ZeYsJwEu0ffnACa+8=";
    patches =
      fixupPatches "math" [
        ./lower-bound-typo.diff
        static-matrix-patch
        ./tail-matrix.diff
      ]
      ++ [
        static-matrix-def-patch
      ];
  };
  z3_4_8_5 = common {
    tag = "Z3";
    version = "4.8.5";
    sha256 = "sha256-ytG5O9HczbIVJAiIGZfUXC/MuYH7d7yLApaeTRlKXoc=";
    patches =
      fixupPatches "util" [
        ./lower-bound-typo.diff
        static-matrix-patch
        ./tail-matrix.diff
      ]
      ++ [
        ./4-8-5-typos.diff
      ];
  };
}
