{ lib, stdenv, cmake, fetchFromGitHub, fetchpatch, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "btor2tools";
  version = "unstable-2024-08-07";

  src = fetchFromGitHub {
    owner  = "boolector";
    repo   = "btor2tools";
    rev    = "44bcadbfede292ff4c4a4a8962cc18130de522fb";
    sha256 = "0ncl4xwms8d656x95ga8v8zjybx4cmdl5hlcml7dpcgm3p8qj4ks";
  };

  nativeBuildInputs = [ cmake ] ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  installPhase = ''
    mkdir -p $out $dev/include/btor2parser/ $lib/lib

    cp -vr bin $out
    cp -v  ../src/btor2parser/btor2parser.h $dev/include/btor2parser
    cp -v  lib/libbtor2parser.* $lib/lib
  '';

  outputs = [ "out" "dev" "lib" ];

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/btorsim contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  meta = with lib; {
    description = "Generic parser and tool package for the BTOR2 format";
    homepage    = "https://github.com/Boolector/btor2tools";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
