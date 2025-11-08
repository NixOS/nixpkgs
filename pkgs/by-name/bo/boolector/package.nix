{
  stdenv,
  fetchFromGitHub,
  lib,
  python3,
  cmake,
  lingeling,
  btor2tools,
  gtest,
  gmp,
}:

stdenv.mkDerivation rec {
  pname = "boolector";
  version = "3.2.4";

  src = fetchFromGitHub {
    owner = "boolector";
    repo = "boolector";
    tag = version;
    hash = "sha256-CKhaPaWUB6Fz0LfnCl81LVmTebCWzTvZLKeC0KH3by4=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.3)" "cmake_minimum_required(VERSION 3.10)"
  '';

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
  ]
  ++ (lib.optional (gmp != null) "-DUSE_GMP=YES");

  nativeCheckInputs = [ python3 ];
  doCheck = true;
  preCheck =
    let
      var = if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
    in
    # tests modelgen and modelgensmt2 spawn boolector in another processes and
    # macOS strips DYLD_LIBRARY_PATH, hardcode it for testing
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      cp -r bin bin.back
      install_name_tool -change libboolector.dylib $(pwd)/lib/libboolector.dylib bin/boolector
    ''
    + ''
      export ${var}=$(readlink -f lib)
      patchShebangs ..
    '';

  postCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    rm -rf bin
    mv bin.back bin
  '';

  # this is what haskellPackages.boolector expects
  postInstall = ''
    cp $out/include/boolector/boolector.h $out/include/boolector.h
    cp $out/include/boolector/btortypes.h $out/include/btortypes.h
  '';

  meta = with lib; {
    description = "Extremely fast SMT solver for bit-vectors and arrays";
    homepage = "https://boolector.github.io";
    license = licenses.mit;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
