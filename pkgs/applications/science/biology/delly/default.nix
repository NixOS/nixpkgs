{ stdenv, fetchpatch, fetchFromGitHub, htslib, zlib, bzip2, lzma, ncurses, boost }:

let
  htslibPatch = fetchpatch {
    url = "https://github.com/dellytools/delly/commit/0e5c710b0c5ea790bb39699d4cbd49cf4fb86f14.diff";
    sha256 = "09bz1qqvzhdzm99hf9zgrv80kq9jlr1m2mdvx96p2hk5lpnbdl7y";
    excludes = [ "src/htslib" ];
  };

in stdenv.mkDerivation rec {
  pname = "delly";
  version = "0.8.2";

  src = fetchFromGitHub {
      owner = "dellytools";
      repo = pname;
      rev = "v${version}";
      sha256 = "14bkmixz7737xj192ww96s3a20zc7xs7r04db8avw3ggi3i1s1cs";
  };

  patches = [ htslibPatch ];

  buildInputs = [ zlib htslib bzip2 lzma ncurses boost ];

  EBROOTHTSLIB = htslib;

  installPhase = ''
    runHook preInstall

    install -Dm555 src/delly $out/bin/delly

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Structural variant caller for mapped DNA sequenced data";
    license = licenses.gpl3;
    maintainers = with maintainers; [ scalavision ];
    platforms = platforms.linux;
    longDescription = ''
      Delly is an integrated structural variant (SV) prediction method
      that can discover, genotype and visualize deletions, tandem duplications,
      inversions and translocations at single-nucleotide resolution in
      short-read massively parallel sequencing data. It uses paired-ends,
      split-reads and read-depth to sensitively and accurately delineate
      genomic rearrangements throughout the genome.
    '';
  };
}
