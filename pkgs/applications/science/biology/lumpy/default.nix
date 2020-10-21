{ stdenv, fetchFromGitHub, htslib, zlib, curl, openssl, samblaster, sambamba
, samtools, hexdump, python2Packages, which }:

let
  python =
    python2Packages.python.withPackages (pkgs: with pkgs; [ pysam numpy ]);

in stdenv.mkDerivation rec {
  pname = "lumpy";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "arq5x";
    repo = "lumpy-sv";
    rev = version;
    sha256 = "0azhzvmh9az9jcq0xprlzdz6w16azgszv4kshb903bwbnqirmk18";
  };

  nativeBuildInputs = [ which ];
  buildInputs =
    [ htslib zlib curl openssl python samblaster sambamba samtools hexdump ];

  preConfigure = ''
    patchShebangs ./.

    # Use Nix htslib over bundled version
    sed -i 's/lumpy_filter: htslib/lumpy_filter:/' Makefile
    sed -i 's|../../lib/htslib/libhts.a|-lhts|' src/filter/Makefile
  '';

  # Upstream's makefile doesn't have an install target
  installPhase = ''
    mkdir -p $out
    cp -r bin $out
    cp -r scripts $out
    sed -i 's|/build/source|'$out'|' $out/bin/lumpyexpress.config
  '';

  meta = with stdenv.lib; {
    description = "Probabilistic structural variant caller";
    homepage = "https://github.com/arq5x/lumpy-sv";
    maintainers = with maintainers; [ jbedo ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };

}
