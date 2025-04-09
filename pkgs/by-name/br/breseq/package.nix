{ stdenv, lib, fetchFromGitHub, callPackage,
libz,
autoconf,
automake,
libtool,
perl,
R,
bowtie2}:

stdenv.mkDerivation rec {
    name = "breseq-${version}";
    version = "0.39.0";

    src = fetchFromGitHub {
        owner = "barricklab";
        repo = "breseq";
        rev = "v${version}";
        sha256 = "DsDX2oGn7Ex50Wnp1phJjCziCzZIeeZOHriUGJbejsk=";
    };

    buildInputs = [
        perl
        libz
        autoconf
        automake
        libtool
    ];

  REQUIRED_R = R.outPath;
  REQUIRED_BOWTIE = bowtie2.outPath;

  buildPhase = ''
    ./bootstrap.sh
    ./configure --prefix=$out/unwrapped
    make -s
  '';

  installPhase = ''
    # Copy over binaries
    make install
    # Make wrappers
    mkdir $out/bin
    touch $out/bin/breseq
    touch $out/bin/gdtools
    echo -e "#! /usr/bin/bash\n\nexport PATH=$REQUIRED_R/bin:$REQUIRED_BOWTIE/bin:\$PATH\n\nexec $out/unwrapped/bin/breseq \$@" >> $out/bin/breseq
    echo -e "#! /usr/bin/bash\n\nexport PATH=$REQUIRED_R/bin:$REQUIRED_BOWTIE/bin:\$PATH\n\nexec $out/unwrapped/bin/gdtools \$@" >> $out/bin/gdtools
    chmod +x $out/bin/breseq
    chmod +x $out/bin/gdtools
    # Clean up dependency tree
    find $out -type f -exec patchelf --shrink-rpath '{}' \; -exec strip '{}' \; 2>/dev/null
    # Copy over tests and license
    cp LICENSE $out/license
    mkdir $out/tests
    mkdir $out/tests/data
    cp tests/data/tmv_plasmid $out/tests/data/tmv_plasmid -r
    cp tests/data/lambda $out/tests/data/lambda -r
    cp tests/common.sh $out/tests/common.sh
    cp tests/tmv_plasmid_circular_deletion $out/tests/tmv_plasmid_circular_deletion -r
    cp tests/gdtools_compare_1 $out/tests/gdtools_compare_1 -r
  '';

  passthru.tests = {
    breseq_works = callPackage ./tests/breseq.nix { };
    gdtools_works = callPackage ./tests/gdtools.nix { };
  };

  meta = with lib; {
    description = "A computational pipeline for finding mutations relative to a reference sequence in short-read DNA re-sequencing data.";
    homepage = "https://github.com/barricklab/breseq";
    license = with lib.licenses; [ gpl2 gpl3 ];
    maintainers = with maintainers; [ croots ];
    platforms = platforms.all;
    };
}
