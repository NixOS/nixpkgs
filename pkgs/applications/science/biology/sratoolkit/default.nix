{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, libidn
, zlib
, bzip2
}:


let
  libidn11 = libidn.overrideAttrs (old: {
    pname = "libidn";
    version = "1.34";
    src = fetchurl {
      url = "mirror://gnu/libidn/libidn-1.34.tar.gz";
      sha256 = "0g3fzypp0xjcgr90c5cyj57apx1cmy0c6y9lvw2qdcigbyby469p";
    };
  });

in

stdenv.mkDerivation rec {
  pname = "sratoolkit";
  version = "2.11.3";

  src = fetchurl {
    url = "https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/${version}/sratoolkit.${version}-ubuntu64.tar.gz";
    sha256 = "1590lc4cplxr3lhjqci8fjncy67imn2h14qd2l87chmhjh243qvx";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    libidn11
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
    description = "The SRA Toolkit and SDK from NCBI is a collection of tools and libraries for using data in the INSDC Sequence Read Archives.";
    license = licenses.ncbiPd;
    maintainers = with maintainers; [ thyol ];
    platforms = [ "x86_64-linux" ];
  };
}
