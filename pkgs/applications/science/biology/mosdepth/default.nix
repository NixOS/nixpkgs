{lib, stdenv, fetchFromGitHub, nim, htslib, pcre}:

let
  hts-nim = fetchFromGitHub {
    owner = "brentp";
    repo = "hts-nim";
    rev = "v0.3.4";
    sha256 = "0670phk1bq3l9j2zaa8i5wcpc5dyfrc0l2a6c21g0l2mmdczffa7";
  };

  docopt = fetchFromGitHub {
    owner = "docopt";
    repo = "docopt.nim";
    rev = "v0.6.7";
    sha256 = "1ga7ckg21fzwwvh26jp2phn2h3pvkn8g8sm13dxif33rp471bv37";
  };

in stdenv.mkDerivation rec {
  pname = "mosdepth";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "brentp";
    repo = "mosdepth";
    rev = "v${version}";
    sha256 = "sha256-uui4yC7ok+pvbXVKfBVsAarH40fnH4fnP8P4uzOqztQ=";
  };

  nativeBuildInputs = [ nim ];
  buildInputs = [ htslib pcre ];

  buildPhase = ''
    HOME=$TMPDIR
    nim -p:${hts-nim}/src -p:${docopt}/src c --nilseqs:on -d:release mosdepth.nim
  '';

  installPhase = "install -Dt $out/bin mosdepth";

  meta = with lib; {
    description = "fast BAM/CRAM depth calculation for WGS, exome, or targeted sequencing";
    license = licenses.mit;
    homepage = "https://github.com/brentp/mosdepth";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.linux;
  };
}
