{ stdenv, fetchFromGitHub, cmake, zlib, gmp, jdk8,
  # The JDK we use on Darwin currenly makes extensive use of rpaths which are
  # annoying and break the python library, so let's not bother for now
  includeJava ? !stdenv.hostPlatform.isDarwin, includeGplCode ? true }:

with stdenv.lib;

let
  boolToCmake = x: if x then "ON" else "OFF";

  rev    = "2deeadeff214e975c9f7508bc8a24fa05a1a0c32";
  sha256 = "09yhym2lxmn3xbhw5fcxawnmvms5jd9fw9m7x2wzil7yvy4vwdjn";

  pname   = "monosat";
  version = substring 0 7 sha256;

  src = fetchFromGitHub {
    owner = "sambayless";
    repo  = pname;
    inherit rev sha256;
  };

  core = stdenv.mkDerivation {
    name = "${pname}-${version}";
    inherit src;
    buildInputs = [ cmake zlib gmp jdk8 ];

    cmakeFlags = [ "-DJAVA=${boolToCmake includeJava}" "-DGPL=${boolToCmake includeGplCode}" ];

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
      broken = true;
    };
  };

  python = { buildPythonPackage, cython }: buildPythonPackage {
    inherit pname version src;

    # The top-level "source" is what fetchFromGitHub gives us. The rest is inside the repo
    sourceRoot = "source/src/monosat/api/python/";

    propagatedBuildInputs = [ core cython ];

    # This tells setup.py to use cython
    MONOSAT_CYTHON = true;

    # The relative paths here don't make sense for our Nix build
    # Also, let's use cython since it should produce faster bindings
    # TODO: do we want to just reference the core monosat library rather than copying the
    # shared lib? The current setup.py copies the .dylib/.so...
    postPatch = ''

      substituteInPlace setup.py \
        --replace '../../../../libmonosat.dylib' '${core}/lib/libmonosat.dylib' \
        --replace '../../../../libmonosat.so'  '${core}/lib/libmonosat.so'
    '';
  };
in core
