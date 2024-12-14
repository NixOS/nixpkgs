{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "multipart-parser-c";
  version = "unstable-2015-12-14";

  src = fetchFromGitHub {
    owner = "iafonov";
    repo = pname;
    rev = "772639cf10db6d9f5a655ee9b7eb20b815fab396";
    sha256 = "056r63vj8f1rwf3wk7jmwhm8ba25l6h1gs6jnkh0schbwcvi56xl";
  };

  buildPhase = ''
    make solib
  '';

  installPhase = ''
    mkdir -p $out/lib
    mv lib*${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/

    mkdir -p $out/include
    mv *.h $out/include/
  '';

  meta = {
    description = "Http multipart parser implemented in C";
    homepage = "https://github.com/iafonov/multipart-parser-c";
    license = [ lib.licenses.mit ];
  };

}
