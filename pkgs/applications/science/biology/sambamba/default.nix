{ lib, stdenv, fetchFromGitHub, python3, which, ldc, zlib }:

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
