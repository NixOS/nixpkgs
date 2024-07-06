{
  lib,
  stdenv,
  fetchurl,
  zlib,
  libpng,
  libjpeg,
  libwebp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "imageworsener";
  version = "1.3.5";

  src = fetchurl {
    url = "https://entropymine.com/${finalAttrs.pname}/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-p/u2XFreZ9nrwy5SxYmIpPmGuswAjJAh/ja1mEZtXI0=";
  };

  postPatch = ''
    patchShebangs tests/runtest
  '';

  postInstall = ''
    mkdir -p $out/share/doc/imageworsener
    cp readme.txt technical.txt $out/share/doc/imageworsener
  '';

  buildInputs = [
    zlib
    libpng
    libjpeg
    libwebp
  ];

  strictDeps = true;

  doCheck = true;

  enableParallelBuilding = true;

  __structuredAttrs = true;

  meta = {
    description = "Raster image scaling and processing utility";
    homepage = "https://entropymine.com/imageworsener/";
    changelog = "https://github.com/jsummers/${finalAttrs.pname}/blob/${finalAttrs.version}/changelog.txt";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.emily
      lib.maintainers.smitop
    ];
    mainProgram = "imagew";
    platforms = lib.platforms.all;
  };
})
