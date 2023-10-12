{ lib, nimPackages, fetchFromGitHub, docopt, hts, pcre }:

nimPackages.buildNimPackage rec {
  pname = "mosdepth";
  version = "0.3.5";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "brentp";
    repo = "mosdepth";
    rev = "v${version}";
    sha256 = "sha256-tG3J51PS6A0WBCZ+j/Nf7aaukFV+DZJsxpbTbvwu0zc=";
  };

  buildInputs = [ docopt hts pcre ];
  nimFlags = hts.nimFlags ++ [ "--threads:off" ];

  meta = with lib; {
    description = "fast BAM/CRAM depth calculation for WGS, exome, or targeted sequencing";
    license = licenses.mit;
    homepage = "https://github.com/brentp/mosdepth";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.linux;
  };
}
