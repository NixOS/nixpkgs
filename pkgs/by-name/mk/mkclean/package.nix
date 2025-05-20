{
  lib,
  stdenv,
  fetchurl,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mkclean";
  version = "0.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/matroska/mkclean-${finalAttrs.version}.tar.bz2";
    hash = "sha256-L1zcqw4Jtl+f74lJpV7wDuPdcA5LQFDiRdRCNH18w9s=";
  };

  nativeBuildInputs = [ cmake ];

  hardeningDisable = [ "format" ];

  postInstall = ''
    install -Dm0755 mkclean/mkclean $out/bin/mkclean
  '';

  meta = {
    description = "Command line tool to clean and optimize Matroska (.mkv / .mka / .mks / .mk3d) and WebM (.webm / .weba) files that have already been muxed";
    homepage = "https://www.matroska.org";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ cawilliamson ];
    platforms = lib.platforms.unix;
  };
})
