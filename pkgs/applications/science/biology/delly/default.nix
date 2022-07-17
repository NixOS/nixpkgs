{ lib, stdenv, fetchpatch, fetchFromGitHub, htslib, zlib, bzip2, xz, ncurses, boost }:

stdenv.mkDerivation rec {
  pname = "delly";
  version = "1.0.3";

  src = fetchFromGitHub {
      owner = "dellytools";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-37AEaTOFmJ2yYXLwjNa7UXBoH/NxOK8+vlXhUhj6CM4=";
  };

  buildInputs = [ zlib htslib bzip2 xz ncurses boost ];

  EBROOTHTSLIB = htslib;

  installPhase = ''
    runHook preInstall

    install -Dm555 src/delly $out/bin/delly

    runHook postInstall
  '';

  meta = with lib; {
    description = "Structural variant caller for mapped DNA sequenced data";
    license = licenses.bsd3;
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
