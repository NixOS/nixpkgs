{
  stdenv,
  fetchFromGitHub,
  lib,
  python3,
  fetchpatch,
  cmake,
  lingeling,
  btor2tools,
  gtest,
  gmp,
}:

stdenv.mkDerivation rec {
  pname = "boolector";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "boolector";
    repo = "boolector";
    rev = version;
    hash = "sha256-CdfpXUbU1+yEmrNyl+hvHlJfpzzzx356naim6vRafDg=";
  };

  patches = [
    # present in master - remove after 3.2.3
    (fetchpatch {
      name = "update-unit-tests-to-cpp-14.patch";
      url = "https://github.com/Boolector/boolector/commit/cc13f371c0c5093d98638ddd213dc835ef3aadf3.patch";
      hash = "sha256-h8DBhAvUu+wXBwmvwRhHnJv3XrbEpBpvX9D1FI/+avc=";
    })
  ];

  nativeBuildInputs = [
    cmake
    gtest
  ];
  buildInputs = [
    lingeling
    btor2tools
    gmp
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DUSE_LINGELING=YES"
    "-DBtor2Tools_INCLUDE_DIR=${btor2tools.dev}/include/btor2parser"
  ] ++ (lib.optional (gmp != null) "-DUSE_GMP=YES");

  nativeCheckInputs = [ python3 ];
  doCheck = true;
  preCheck =
    let
      var = if stdenv.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
    in
    # tests modelgen and modelgensmt2 spawn boolector in another processes and
    # macOS strips DYLD_LIBRARY_PATH, hardcode it for testing
    lib.optionalString stdenv.isDarwin ''
      cp -r bin bin.back
      install_name_tool -change libboolector.dylib $(pwd)/lib/libboolector.dylib bin/boolector
    ''
    + ''
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
    homepage = "https://boolector.github.io";
    license = licenses.mit;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
