{
  lib,
  stdenvNoCC,
  fetchurl,
  mkfontdir,
  mkfontscale,
}:

stdenvNoCC.mkDerivation rec {
  pname = "arphic-uming";
  version = "0.2.20080216.2";

  src = fetchurl {
    url = "mirror://ubuntu/pool/main/f/fonts-arphic-uming/fonts-arphic-uming_${version}.orig.tar.bz2";
    hash = "sha256-48GeBOp6VltKz/bx5CSAhNLhB1LjBb991sdugIYNwds=";
  };

  nativeBuildInputs = [
    mkfontscale
    mkfontdir
  ];

  installPhase = ''
    runHook preInstall

    install -D -v uming.ttc $out/share/fonts/truetype/arphic-uming.ttc
    cd $out/share/fonts
    mkfontdir
    mkfontscale

    runHook postInstall
  '';

  meta = {
    description = "CJK Unicode font Ming style";
    homepage = "https://www.freedesktop.org/wiki/Software/CJKUnifonts/";

    license = lib.licenses.arphicpl;
    maintainers = [ lib.maintainers.changlinli ];
    platforms = lib.platforms.all;
  };
}
