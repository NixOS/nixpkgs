{ lib, stdenv, fetchFromGitHub, fetchpatch, python3, which, ldc, zlib }:

stdenv.mkDerivation rec {
  pname = "sambamba";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "biod";
    repo = "sambamba";
    rev = "v${version}";
    sha256 = "sha256:0kx5a0fmvv9ldz2hnh7qavgf7711kqc73zxf51k4cca4hr58zxr9";
    fetchSubmodules = true;
  };

  patches = [
    # Fixes hardcoded gcc, making clang build possible.
    (fetchpatch {
      url = "https://github.com/biod/sambamba/commit/c50a1c91e1ba062635467f197139bf6784e9be15.patch";
      sha256 = "1y0vlybmb9wpg4z1nca7m96mk9hxmvd3yrg7w8rxscj45hcqvf8q";
    })
  ];

  nativeBuildInputs = [ which python3 ldc ];
  buildInputs = [ zlib ];

  # Upstream's install target is broken; copy manually
  installPhase = ''
    mkdir -p $out/bin
    cp bin/sambamba-${version} $out/bin/sambamba
  '';

  meta = with lib; {
    description = "SAM/BAM processing tool";
    homepage = "https://lomereiter.github.io/sambamba/";
    maintainers = with maintainers; [ jbedo ];
    license = with licenses; gpl2;
    platforms = platforms.x86_64;
  };
}
