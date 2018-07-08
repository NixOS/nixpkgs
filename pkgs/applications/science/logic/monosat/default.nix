{ stdenv, fetchFromGitHub, cmake, zlib, gmp, jdk8,
  # The JDK we use on Darwin currenly makes extensive use of rpaths which are
  # annoying and break the python library, so let's not bother for now
  includeJava ? !stdenv.hostPlatform.isDarwin, includeGplCode ? true }:

with stdenv.lib;

let
  boolToCmake = x: if x then "ON" else "OFF";

  rev    = "cbaf79cfd01cba97b46cae5a9d7b832771ff442c";
  sha256 = "1nx3wh34y53lrwgh94cskdrdyrj26jn3py7z2cn4bvacz0wzhi6n";

  pname   = "monosat";
  version = substring 0 7 sha256;

  src = fetchFromGitHub {
    owner = "sambayless";
    repo  = pname;
    inherit rev sha256;
  };

  core = stdenv.mkDerivation rec {
    name = "${pname}-${version}";
    inherit src;
    buildInputs = [ cmake zlib gmp jdk8 ];

    cmakeFlags = [ "-DJAVA=${boolToCmake includeJava}" "-DGPL=${boolToCmake includeGplCode}" ];

    # Minor logic bug: https://github.com/sambayless/monosat/issues/11#issuecomment-403297720
    postPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace '"&&" "true"' '"||" "true"'
    '';

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
    };
  };

  python = { buildPythonPackage, cython }: buildPythonPackage {
    inherit pname version src;

    # The top-level "source" is what fetchFromGitHub gives us. The rest is inside the repo
    sourceRoot = "source/src/monosat/api/python/";

    propagatedBuildInputs = [ core cython ];

    # The relative paths here don't make sense for our Nix build
    # Also, let's use cython since it should produce faster bindings
    # TODO: do we want to just reference the core monosat library rather than copying the
    # shared lib? The current setup.py copies the .dylib/.so...
    postPatch = ''
      substituteInPlace setup.py \
        --replace '../../../../libmonosat.dylib' '${core}/lib/libmonosat.dylib' \
        --replace '../../../../libmonosat.so'  '${core}/lib/libmonosat.so' \
        --replace 'use_cython=False' 'use_cython=True'

      # This seems to be forgotten and unused. See https://github.com/sambayless/monosat/issues/10
      rm monosat/cnf.py
    '';
  };
in core