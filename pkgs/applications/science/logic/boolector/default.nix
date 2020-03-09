{ stdenv, fetchFromGitHub, fetchpatch
, cmake, lingeling, btor2tools
}:

stdenv.mkDerivation rec {
  pname = "boolector";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner  = "boolector";
    repo   = "boolector";
    rev    = "refs/tags/${version}";
    sha256 = "15i3ni5klss423m57wcy1gx0m5wfrjmglapwg85pm7fb3jj1y7sz";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2019-7560.patch";
      url = "https://github.com/Boolector/boolector/commit/8d979d02e0482c7137c9f3a34e6d430dbfd1f5c5.patch";
      sha256 = "1a1g02mk8b0azzjcigdn5zpshn0dn05fciwi8sd5q38yxvnvpbbi";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ lingeling btor2tools ];

  cmakeFlags =
    [ "-DSHARED=ON"
      "-DUSE_LINGELING=YES"
      "-DBTOR2_INCLUDE_DIR=${btor2tools.dev}/include"
      "-DBTOR2_LIBRARIES=${btor2tools.lib}/lib/libbtor2parser.so"
      "-DLINGELING_INCLUDE_DIR=${lingeling.dev}/include"
      "-DLINGELING_LIBRARIES=${lingeling.lib}/lib/liblgl.a"
    ];

  installPhase = ''
    mkdir -p $out/bin $lib/lib $dev/include

    cp -vr bin/* $out/bin
    cp -vr lib/* $lib/lib

    rm -rf $out/bin/{examples,test}

    cd ../src
    find . -iname '*.h' -exec cp --parents '{}' $dev/include \;
    rm -rf $dev/include/tests
  '';

  outputs = [ "out" "dev" "lib" ];

  meta = with stdenv.lib; {
    description = "An extremely fast SMT solver for bit-vectors and arrays";
    homepage    = https://boolector.github.io;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
