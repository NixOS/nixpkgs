{ lib, stdenv, fetchFromGitHub, htslib, zlib, bzip2, xz, ncurses, boost, runCommand, delly }:

stdenv.mkDerivation rec {
  pname = "delly";
  version = "1.1.6";

  src = fetchFromGitHub {
      owner = "dellytools";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-/I//7MhsC/CcBeIJblzbjXp/yOSBm83KWJsrYpl6UJk=";
  };

  buildInputs = [ zlib htslib bzip2 xz ncurses boost ];

  EBROOTHTSLIB = htslib;

  installPhase = ''
    runHook preInstall

    install -Dm555 src/delly $out/bin/delly

    runHook postInstall
  '';

  passthru.tests = {
    simple = runCommand "${pname}-test" { } ''
      mkdir $out
      ${lib.getExe delly} call -g ${delly.src}/example/ref.fa ${delly.src}/example/sr.bam > $out/sr.vcf
      ${lib.getExe delly} lr -g ${delly.src}/example/ref.fa ${delly.src}/example/lr.bam > $out/lr.vcf
      ${lib.getExe delly} cnv -g ${delly.src}/example/ref.fa -m ${delly.src}/example/map.fa.gz ${delly.src}/example/sr.bam > cnv.vcf
    '';
  };

  meta = with lib; {
    description = "Structural variant caller for mapped DNA sequenced data";
    license = licenses.bsd3;
    maintainers = with maintainers; [ scalavision ];
    platforms = platforms.unix;
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
