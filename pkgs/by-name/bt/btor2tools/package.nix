{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation {
  pname = "btor2tools";
  version = "0-unstable-2025-09-18";

  src = fetchFromGitHub {
    owner = "boolector";
    repo = "btor2tools";
    rev = "d33c73ff1d173f1bfac8ba6b1c6d68ba62c55f8e";
    sha256 = "sha256-RVjZ5HM2yQ3eAICFuzwvNeQDXzWzzSiCCslIWMJi6U8=";
  };

  nativeBuildInputs = [ cmake ] ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  installPhase = ''
    mkdir -p $out $dev/include/btor2parser/ $lib/lib

    cp -vr bin $out
    cp -v  ../src/btor2parser/btor2parser.h $dev/include/btor2parser
    cp -v  lib/libbtor2parser.* $lib/lib
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    # make sure shared libraries are present and program can be executed
    $out/bin/btorsim -h > /dev/null

    runHook postInstallCheck
  '';

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/btorsim contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON"
  ];

  meta = with lib; {
    description = "Generic parser and tool package for the BTOR2 format";
    homepage = "https://github.com/Boolector/btor2tools";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
