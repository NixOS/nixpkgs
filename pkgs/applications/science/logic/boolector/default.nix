{ stdenv, fetchFromGitHub, fetchpatch, lib, python3
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

  # excludes development artifacts from install, will be included in next release
  patches = [
    (fetchpatch {
      url = "https://github.com/Boolector/boolector/commit/4d240436e34e65096671099766344dd9126145b1.patch";
      sha256 = "1girsbvlhkkl1hldl2gsjynwc3m92jskn798qhx0ydg6whrfgcgw";
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

  checkInputs = [ python3 ];
  doCheck = true;
  preCheck =
    let var = if stdenv.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
    in
      # tests modelgen and modelgensmt2 spawn boolector in another processes and
      # macOS strips DYLD_LIBRARY_PATH, hardcode it for testing
      stdenv.lib.optionalString stdenv.isDarwin ''
        cp -r bin bin.back
        install_name_tool -change libboolector.dylib $(pwd)/lib/libboolector.dylib bin/boolector
      '' + ''
        export ${var}=$(readlink -f lib)
        patchShebangs ..
      '';

  postCheck = stdenv.lib.optionalString stdenv.isDarwin ''
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
