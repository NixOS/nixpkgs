{ lib
, stdenv
, fetchFromGitHub
, boost
, bzip2
, htslib
, llvmPackages
, xz
, zlib
, delly
, runCommand
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "delly";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "dellytools";
    repo = "delly";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/I//7MhsC/CcBeIJblzbjXp/yOSBm83KWJsrYpl6UJk=";
  };

  buildInputs = [
    boost
    bzip2
    htslib
    xz
    zlib
  ] ++ lib.optional stdenv.isDarwin llvmPackages.openmp;

  makeFlags = [
    "EBROOTHTSLIB=${htslib}"
    "PARALLEL=1"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm555 src/delly $out/bin/delly

    runHook postInstall
  '';

  passthru.tests = {
    simple = runCommand "${finalAttrs.pname}-test" { } ''
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
})
