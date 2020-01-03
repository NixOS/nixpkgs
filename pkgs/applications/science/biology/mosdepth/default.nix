{stdenv, fetchFromGitHub, nim, htslib, pcre}:

let
  hts-nim = fetchFromGitHub {
    owner = "brentp";
    repo = "hts-nim";
    rev = "v0.2.14";
    sha256 = "0d1z4b6mrppmz3hgkxd4wcy79w68icvhi7q7n3m2k17n8f3xbdx3";
  };

  docopt = fetchFromGitHub {
    owner = "docopt";
    repo = "docopt.nim";
    rev = "v0.6.7";
    sha256 = "1ga7ckg21fzwwvh26jp2phn2h3pvkn8g8sm13dxif33rp471bv37";
  };

in stdenv.mkDerivation rec {
  pname = "mosdepth";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "brentp";
    repo = "mosdepth";
    rev = "v${version}";
    sha256 = "0i9pl9lsli3y84ygxanrr525gfg8fs9h481944cbzsmqmbldwvgk";
  };

  buildInputs = [ nim ];

  buildPhase = ''
    HOME=$TMPDIR
    nim -p:${hts-nim}/src -p:${docopt}/src c --nilseqs:on -d:release mosdepth.nim
  '';
  installPhase = "install -Dt $out/bin mosdepth";
  fixupPhase = "patchelf --set-rpath ${stdenv.lib.makeLibraryPath [ stdenv.cc.cc htslib pcre ]} $out/bin/mosdepth";

  meta = with stdenv.lib; {
    description = "fast BAM/CRAM depth calculation for WGS, exome, or targeted sequencing.";
    license = licenses.mit;
    homepage = https://github.com/brentp/mosdepth;
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.linux;
  };
}
