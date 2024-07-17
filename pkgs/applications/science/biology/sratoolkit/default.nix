{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, libidn2
, zlib
, bzip2
}:

stdenv.mkDerivation rec {
  pname = "sratoolkit";
  version = "3.1.1";

  src = fetchurl {
    url = "https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/${version}/sratoolkit.${version}-ubuntu64.tar.gz";
    sha256 = "sha256-tmjb+i6TBBdG0cMTaRJyrqS56lKykdevt51G3AU2dog=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    libidn2
    zlib
    bzip2
    stdenv.cc.cc.lib
  ];

  sourceRoot = "sratoolkit.${version}-ubuntu64/bin";

  installPhase = ''
    find -L . -executable -type f -! -name "*remote-fuser*" -exec install -m755 -D {} $out/bin/{} \;
  '';

  meta = with lib; {
    homepage = "https://github.com/ncbi/sra-tools";
    description = "SRA Toolkit and SDK from NCBI is a collection of tools and libraries for using data in the INSDC Sequence Read Archives";
    license = licenses.ncbiPd;
    maintainers = with maintainers; [ thyol ];
    platforms = [ "x86_64-linux" ];
  };
}
