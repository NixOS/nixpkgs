{ stdenv, fetchFromGitHub, lib, python3
, cmake, lingeling, btor2tools, gtest, gmp
}:

stdenv.mkDerivation rec {
  pname = "boolector";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner  = "boolector";
    repo   = "boolector";
    rev    = "refs/tags/${version}";
    sha256 = "0jkmaw678njqgkflzj9g374yk1mci8yqvsxkrqzlifn6bwhwb7ci";
  };

  postPatch = ''
    sed s@REPLACEME@file://${gtest.src}@ ${./cmake-gtest.patch} | patch -p1
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ lingeling btor2tools gmp ];

  cmakeFlags =
    [ "-DBUILD_SHARED_LIBS=ON"
      "-DUSE_LINGELING=YES"
      "-DBtor2Tools_INCLUDE_DIR=${btor2tools.dev}/include"
      "-DBtor2Tools_LIBRARIES=${btor2tools.lib}/lib/libbtor2parser.so"
    ] ++ (lib.optional (gmp != null) "-DUSE_GMP=YES");

  installPhase = ''
    mkdir -p $out/bin $lib/lib $dev/include

    cp -vr bin/* $out/bin
    cp -vr lib/* $lib/lib

    rm -rf $out/bin/{examples,tests}
    # we don't care about gtest related libs
    rm -rf $lib/lib/libg*

    cd ../src
    find . -iname '*.h' -exec cp --parents '{}' $dev/include \;
    rm -rf $dev/include/tests
  '';

  checkInputs = [ python3 ];
  doCheck = true;
  preCheck = ''
    export LD_LIBRARY_PATH=$(readlink -f lib)
    patchShebangs ..
  '';

  outputs = [ "out" "dev" "lib" ];

  meta = with stdenv.lib; {
    description = "An extremely fast SMT solver for bit-vectors and arrays";
    homepage    = "https://boolector.github.io";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
