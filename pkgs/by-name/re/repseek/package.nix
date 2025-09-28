{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "repseek";
  version = "9Sep2014";
  src = fetchurl {
    url = "https://bioinfo.mnhn.fr/abi/public/RepSeek/RepSeek.${version}.tgz";
    sha256 = "1jiknji3ivrv7zmrfbf2mccfpdwhin3lfxfsciaqwf69b3sda8nf";
  };

  preConfigure = ''
    mkdir -p $out/bin
    substituteInPlace Makefile \
      --replace "INSTALLDIR = \$\$HOME/bin" "INSTALLDIR = $out/bin/" \
      --replace "CC= gcc" "CC = $CC"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace Makefile --replace "MACHINE = MACOSX" "MACHINE = LINUX"
  '';

  meta = {
    description = "Tool to retrieve approximate repeats from large DNA sequences";
    mainProgram = "repseek";
    homepage = "https://bioinfo.mnhn.fr/abi/public/RepSeek";
    maintainers = [ lib.maintainers.bzizou ];
    license = lib.licenses.lgpl21;
  };

}
