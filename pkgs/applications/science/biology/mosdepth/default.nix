{lib, nimPackages, fetchFromGitHub, pcre}:

nimPackages.buildNimPackage rec {
  pname = "mosdepth";
  version = "0.3.3";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "brentp";
    repo = "mosdepth";
    rev = "v${version}";
    sha256 = "sha256-de3h3SXnXlqjuLT1L66jj/1AoiTuFc3PVJYjm7s8Fj8=";
  };

  buildInputs = with nimPackages; [ docopt hts-nim pcre ];

  meta = with lib; {
    description = "fast BAM/CRAM depth calculation for WGS, exome, or targeted sequencing";
    license = licenses.mit;
    homepage = "https://github.com/brentp/mosdepth";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.linux;
  };
}
