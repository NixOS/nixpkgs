{
  lib,
  stdenv,
  fetchurl,
  libfaketime,
  mkfontscale,
  fonttosfnt,
  bdftopcf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "efont-unicode";
  version = "0.4.2";

  src = fetchurl {
    url = "http://openlab.ring.gr.jp/efont/dist/unicode-bdf/efont-unicode-bdf-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-fT7SsYlV3dCQrf0IZfiNI1grj3ngDgr8IkWdg+f9m3M=";
  };

  nativeBuildInputs = [
    libfaketime
    bdftopcf
    fonttosfnt
    mkfontscale
  ];

  buildPhase = ''
    runHook preBuild

    # convert bdf fonts to pcf
    for f in *.bdf; do
        bdftopcf -t -o "''${f%.bdf}.pcf" "$f"
    done
    gzip -n -9 *.pcf

    # convert bdf fonts to otb
    for f in *.bdf; do
        faketime -f "1970-01-01 00:00:01" \
        fonttosfnt -v -m 2 -o "''${f%.bdf}.otb" "$f"
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    dir=share/fonts/misc
    install -D -m 644 -t "$out/$dir" *.otb *.pcf.gz
    install -D -m 644 -t "$bdf/$dir" *.bdf
    mkfontdir "$out/$dir"
    mkfontdir "$bdf/$dir"

    runHook postInstall
  '';

  outputs = [
    "out"
    "bdf"
  ];

  meta = {
    description = "/efont/ Unicode bitmap font";
    homepage = "http://openlab.ring.gr.jp/efont/unicode/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.ncfavier ];
  };
})
