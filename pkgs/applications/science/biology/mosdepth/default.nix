{lib, nimPackages, fetchFromGitHub, pcre}:

nimPackages.buildNimPackage rec {
  pname = "mosdepth";
  version = "0.3.2";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "brentp";
    repo = "mosdepth";
    rev = "v${version}";
    sha256 = "sha256-uui4yC7ok+pvbXVKfBVsAarH40fnH4fnP8P4uzOqztQ=";
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
