{ stdenv, fetchFromGitHub, lib, autoconf, automake, libtool, gettext, pkg-config }:

stdenv.mkDerivation rec {
    pname = "jellyfish";
    version = "2.3.0";

    src = fetchFromGitHub {
        owner = "gmarcais";
        repo = pname;
        rev = "v${version}";
        sha256 = "1d9f0ni2ll1basc5p0shwb4gq1iz1ahnzv2imfgb93bihyvcmq66";
    };

    buildInputs = [ autoconf automake libtool gettext pkg-config ];

    preConfigure = ''
        autoreconf -i
    '';

    meta = with lib; {
        description = "A fast multi-threaded k-mer counter";
        longDescription = ''
            Jellyfish is a tool for fast, memory-efficient counting of k-mers in DNA. A k-mer is a substring of length k, and counting the occurrences of all such substrings is a central step in many analyses of DNA sequence. Jellyfish can count k-mers using an order of magnitude less memory and an order of magnitude faster than other k-mer counting packages by using an efficient encoding of a hash table and by exploiting the "compare-and-swap" CPU instruction to increase parallelism.

            JELLYFISH is a command-line program that reads FASTA and multi-FASTA files containing DNA sequences. It outputs its k-mer counts in a binary format, which can be translated into a human-readable text format using the "jellyfish dump" command, or queried for specific k-mers with "jellyfish query". See the documentation for details.

            If you use Jellyfish in your research, please cite:

            Guillaume Marcais and Carl Kingsford, A fast, lock-free approach for efficient parallel counting of occurrences of k-mers. Bioinformatics (2011) 27(6): 764-770 (first published online January 7, 2011) doi:10.1093/bioinformatics/btr011
        '';
        branch = "master";
        homepage = "https://github.com/${owner}/${repo}";
        downloadPage = "https://github.com/${owner}/${repo}/releases";
        changelog = "https://github.com/${owner}/${repo}/blob/master/CHANGES";
        license = with lib.licenses; [ bsd3 gpl3Only ];
        maintainers = [ maintainers.giang ];
        platforms = platforms.linux;
    };
}
