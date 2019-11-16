{ stdenv, fetchFromGitHub, cmake, zlib, gmp, jdk8,
  # The JDK we use on Darwin currenly makes extensive use of rpaths which are
  # annoying and break the python library, so let's not bother for now
  includeJava ? !stdenv.hostPlatform.isDarwin, includeGplCode ? true }:

with stdenv.lib;

let
  boolToCmake = x: if x then "ON" else "OFF";

  rev    = "1.8.0";
  sha256 = "0q3a8x3iih25xkp2bm842sm2hxlb8hxlls4qmvj7vzwrh4lvsl7b";

  pname   = "monosat";
  version = rev;

  src = fetchFromGitHub {
    owner = "sambayless";
    repo  = pname;
    inherit rev sha256;
  };

  core = stdenv.mkDerivation {
    name = "${pname}-${version}";
    inherit src;
    buildInputs = [ cmake zlib gmp jdk8 ];

    cmakeFlags = [
      "-DBUILD_STATIC=OFF"
      "-DJAVA=${boolToCmake includeJava}"
      "-DGPL=${boolToCmake includeGplCode}"
    ];

    postInstall = optionalString includeJava ''
      mkdir -p $out/share/java
      cp monosat.jar $out/share/java
    '';

    passthru = { inherit python; };

    meta = {
      description = "SMT solver for Monotonic Theories";
      platforms   = platforms.unix;
      license     = if includeGplCode then licenses.gpl2 else licenses.mit;
      homepage    = https://github.com/sambayless/monosat;
      maintainers = [ maintainers.acairncross ];
    };
  };

  python = { buildPythonPackage, cython }: buildPythonPackage {
    inherit pname version src;

    # The top-level "source" is what fetchFromGitHub gives us. The rest is inside the repo
    sourceRoot = "source/src/monosat/api/python/";

    propagatedBuildInputs = [ core cython ];

    # This tells setup.py to use cython, which should produce faster bindings
    MONOSAT_CYTHON = true;

    # The relative paths here don't make sense for our Nix build
    # TODO: do we want to just reference the core monosat library rather than copying the
    # shared lib? The current setup.py copies the .dylib/.so...
    postPatch = ''
      substituteInPlace setup.py \
        --replace 'library_dir = "../../../../"' 'library_dir = "${core}/lib/"'
    '';
  };
in core
