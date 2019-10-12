{ stdenv, fetchFromGitHub, htslib, zlib, bzip2, lzma, ncurses, boost }:

stdenv.mkDerivation rec {
  pname = "delly";
  version = "0.8.1";

  src = fetchFromGitHub {
      owner = "dellytools";
      repo = pname;
      rev = "v${version}";
      sha256 = "18gm86j1g1k4z1cjv2m5v9rsl1xqs2w3dhwcsnzx2mhkrvmlc4i1";
  };

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
