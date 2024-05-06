{ dos2unix, fetchurl, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "mkclean";
  version = "0.8.10";

  hardeningDisable = [ "format" ];
  nativeBuildInputs = [ dos2unix ];

  src = fetchurl {
    url = "mirror://sourceforge/matroska/${pname}-${version}.tar.bz2";
    sha256 = "0zbpi4sm68zb20d53kbss93fv4aafhcmz7dsd0zdf01vj1r3wxwn";
  };

  configurePhase = ''
    dos2unix ./mkclean/configure.compiled
    ./mkclean/configure.compiled
  '';

  buildPhase = ''
    make -C mkclean
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib}
    mv release/gcc_linux_*/*.* $out/lib
    mv release/gcc_linux_*/* $out/bin
  '';

  meta = with lib; {
    description = "Command line tool to clean and optimize Matroska (.mkv / .mka / .mks / .mk3d) and WebM (.webm / .weba) files that have already been muxed";
    homepage = "https://www.matroska.org";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ cawilliamson ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
