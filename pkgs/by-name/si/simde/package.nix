{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "simde";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "simd-everywhere";
    repo = "simde";
    rev = "v${version}";
    hash = "sha256-pj+zaD5o9XYkTavezcQFzM6ao0IdQP1zjP9L4vcCyEY=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    cp -a ${pname} $out/include

    install -Dt $out/share/doc/${pname} README.md

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://simd-everywhere.github.io";
    description = "Implementations of SIMD instruction sets for systems which don't natively support them.";
    license = with licenses; [mit];
    platforms = platforms.unix;
  };
}
