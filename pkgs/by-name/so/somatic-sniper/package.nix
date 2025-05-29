{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "somatic-sniper";
  version = "1.0.5.0";

  src = fetchFromGitHub {
    owner = "genome";
    repo = "somatic-sniper";
    rev = "v${version}";
    sha256 = "0lk7p9sp6mp50f6w1nppqhr40fcwy1asw06ivw8w8jvvnwaqf987";
  };

  patches = [ ./somatic-sniper.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    zlib
    ncurses
  ];

  enableParallelBuilding = false;

  meta = with lib; {
    description = "Identify single nucleotide positions that are different between tumor and normal";
    mainProgram = "bam-somaticsniper";
    license = licenses.mit;
    homepage = "https://github.com/genome/somatic-sniper";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.linux;
  };

}
