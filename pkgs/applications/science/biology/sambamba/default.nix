{ lib, stdenv, fetchFromGitHub, fetchpatch, python3, which, ldc, zlib }:

stdenv.mkDerivation rec {
  pname = "sambamba";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "biod";
    repo = "sambamba";
    rev = "v${version}";
    sha256 = "0f4qngnys2zjb0ri54k6kxqnssg938mnnscs4z9713hjn41rk7yd";
    fetchSubmodules = true;
  };

  patches = [
    # make ldc 1.27.1 compatible
    (fetchpatch {
      url = "https://github.com/biod/sambamba/pull/480/commits/b5c80feb62683d24ec0529f685a1d7a36962a1d4.patch";
      sha256 = "0yr9baxqbhyb4scwcwczk77z8gazhkl60jllhz9dnrb7p5qsvs7r";
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
