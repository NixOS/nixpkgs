{
  lib,
  stdenvNoCC,
  fetchurl,
  mkfontscale,
}:

stdenvNoCC.mkDerivation rec {
  pname = "spleen";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/fcambus/spleen/releases/download/${version}/spleen-${version}.tar.gz";
    hash = "sha256-7EKSXGtW0hOMhisvlxR8hy5HL2dL8DQjQX2CegjWmok=";
  };

  nativeBuildInputs = [ mkfontscale ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    d="$out/share/fonts/misc"
    install -D -m 644 *.{pcf,bdf,otf} -t "$d"
    install -D -m 644 *.psfu -t "$out/share/consolefonts"
    install -m644 fonts.alias-spleen $d/fonts.alias

    # create fonts.dir so NixOS xorg module adds to fp
    mkfontdir "$d"

    runHook postInstall
  '';

  meta = {
    description = "Monospaced bitmap fonts";
    homepage = "https://www.cambus.net/spleen-monospaced-bitmap-fonts";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
