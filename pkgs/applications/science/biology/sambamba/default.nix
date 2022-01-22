{ lib
, stdenv
, fetchFromGitHub
, python3
, which
, ldc
, zlib
, lz4
}:

stdenv.mkDerivation rec {
  pname = "sambamba";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "biod";
    repo = "sambamba";
    rev = "v${version}";
    sha256 = "sha256-FEa9QjQoGNUOAtMNMZcqpTKMKVtXoBuOomTy0mpos/0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ which python3 ldc ];
  buildInputs = [ zlib lz4 ];

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
