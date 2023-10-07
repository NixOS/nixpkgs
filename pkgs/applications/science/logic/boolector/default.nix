{ stdenv, fetchFromGitHub, lib, python3, fetchpatch
, cmake, lingeling, btor2tools, gtest, gmp
}:

stdenv.mkDerivation rec {
  pname = "boolector";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner  = "boolector";
    repo   = "boolector";
    rev    = version;
    sha256 = "1smcy6yp8wvnw2brgnv5bf40v87k4v4fbdbrhi7987vja632k50z";
  };

  patches = [
    # present in master - remove after 3.2.2
    (fetchpatch {
      name = "fix-parser-getc-char-casts.patch";
      url = "https://github.com/Boolector/boolector/commit/cc3a70918538c1e71ea5e7273fa1ac098da37c1b.patch";
      sha256 = "0pjvagcy74vxa2q75zbshcz8j7rvhl98549xfcf5y8yyxf5h8hyq";
    })
  ];

  postPatch = ''
    sed s@REPLACEME@file://${gtest.src}@ ${./cmake-gtest.patch} | patch -p1
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ lingeling btor2tools gmp ];

  cmakeFlags =
    [ "-DBUILD_SHARED_LIBS=ON"
      "-DUSE_LINGELING=YES"
    ] ++ (lib.optional (gmp != null) "-DUSE_GMP=YES");

  nativeCheckInputs = [ python3 ];
  doCheck = true;
  preCheck =
    let var = if stdenv.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
    in
      # tests modelgen and modelgensmt2 spawn boolector in another processes and
      # macOS strips DYLD_LIBRARY_PATH, hardcode it for testing
      lib.optionalString stdenv.isDarwin ''
        cp -r bin bin.back
        install_name_tool -change libboolector.dylib $(pwd)/lib/libboolector.dylib bin/boolector
      '' + ''
        export ${var}=$(readlink -f lib)
        patchShebangs ..
      '';

  postCheck = lib.optionalString stdenv.isDarwin ''
    rm -rf bin
    mv bin.back bin
  '';

  # this is what haskellPackages.boolector expects
  postInstall = ''
    cp $out/include/boolector/boolector.h $out/include/boolector.h
    cp $out/include/boolector/btortypes.h $out/include/btortypes.h
  '';

  meta = with lib; {
    description = "An extremely fast SMT solver for bit-vectors and arrays";
    homepage    = "https://boolector.github.io";
    license     = licenses.mit;
    platforms   = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
