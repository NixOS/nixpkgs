{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  python3Packages,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "libre-bodoni";
  version = "2.005-unstable-2023-02-08";

  outputs = [
    "out"
    "webfont"
    "doc"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "Libre-Bodoni";
    rev = "37d048938a8a32e6ba3992072cb3857659a7828f";
    hash = "sha256-wqdeJ0prag8BbT3hhXmSUk4X170ytSwPaJHBHMQH7bo=";
  };

  env.PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";

  nativeBuildInputs = [
    python3Packages.gftools
    installFonts
  ];

  buildPhase = ''
    runHook preBuild
    # clean out the prebuilt files
    rm -r fonts
    gftools builder sources/config.yaml
    runHook postBuild
  '';

  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;

  preInstall = ''
    rm -r old
  '';

  postInstall = ''
    install -Dm444 README.md FONTLOG.txt -t $doc/share/doc/${finalAttrs.pname}-${finalAttrs.version}
  '';

  meta = {
    description = "Bodoni fonts adapted for today's web requirements";
    longDescription = ''
      The Libre Bodoni fonts are based on the 19th century Morris Fuller
      Benton's ATF design, but specifically adapted for today's web
      requirements.

      They are a perfect choice for everything related to elegance, style,
      luxury and fashion.

      Libre Bodoni currently features four styles: Regular, Italic, Bold and
      Bold Italic.
    '';
    homepage = "https://github.com/googlefonts/Libre-Bodoni";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = lib.platforms.all;
  };
})
