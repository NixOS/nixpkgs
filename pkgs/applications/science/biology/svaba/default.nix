{ stdenv, zlib, bzip2, lzma, fetchFromGitHub } :

stdenv.mkDerivation rec {
  version = "1.1.0";
  pname = "svaba";

  src = fetchFromGitHub {
    owner = "walaj";
    repo = pname;
    rev = version;
    sha256 = "1vv5mc9z5d22kgdy7mm27ya5aahnqgkcrskdr2405058ikk9g8kp";
    fetchSubmodules = true;
  };

  buildInputs = [ zlib bzip2 lzma ];

  installPhase = ''
    runHook preInstall
    install -Dm555 src/svaba/svaba $out/bin/svaba
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Structural variant and INDEL caller for DNA sequencing data, using genome-wide local assembly";
    license = licenses.gpl3;
    homepage = "https://github.com/walaj/svaba";
    maintainers = with maintainers; [ scalavision ];
    platforms = platforms.linux;
    longDescription = ''
      SvABA is a method for detecting structural variants in sequencing data
      using genome-wide local assembly. Under the hood, SvABA uses a custom
      implementation of SGA (String Graph Assembler) by Jared Simpson,
      and BWA-MEM by Heng Li. Contigs are assembled for every 25kb window
      (with some small overlap) for every region in the genome.
      The default is to use only clipped, discordant, unmapped and indel reads,
      although this can be customized to any set of reads at the command line using VariantBam rules.
      These contigs are then immediately aligned to the reference with BWA-MEM and parsed to identify variants.
      Sequencing reads are then realigned to the contigs with BWA-MEM, and variants are scored by their read support.
    '';

  };
}
