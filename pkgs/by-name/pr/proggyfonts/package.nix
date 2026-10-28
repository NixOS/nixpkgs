{
  lib,
  stdenv,
  fetchurl,
  mkfontscale,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "proggyfonts";
  version = "0.1";

  src = fetchurl {
    url = "https://web.archive.org/web/20150801042353/http://kaictl.net/software/proggyfonts-${finalAttrs.version}.tar.gz";
    hash = "sha256-SsLzZdR5icVJNbr5rcCPbagPPtWghbqs2Jxmrtufsa4=";
  };

  nativeBuildInputs = [
    mkfontscale
    installFonts
  ];

  dontConfigure = true;
  dontBuild = true;

  preInstall = ''
    rm Speedy.pcf # duplicated as Speedy11.pcf

    # compress pcf fonts
    for f in *.pcf; do
      gzip -n -9 -c "$f" > "$f".gz
    done

    rm *.pcf
  '';

  postInstall = ''
    install -D -m 644 Licence.txt -t "$out/share/doc/$name"

    mkfontscale "$out/share/fonts/truetype"
    mkfontdir   "$out/share/fonts/misc"
  '';

  meta = {
    homepage = "https://github.com/bluescan/proggyfonts";
    description = "Set of fixed-width screen fonts that are designed for code listings";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.myrl ];
  };
})
