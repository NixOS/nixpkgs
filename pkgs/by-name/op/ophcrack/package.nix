{
  lib,
  stdenv,
  libsForQt5,
  fetchurl,
  fetchpatch,
  pkg-config,
  openssl,
  expat,
  enableGui ? true,
}:
stdenv.mkDerivation (finalAttrs: {

  pname = "ophcrack";
  version = "3.8.0";

  src = fetchurl {
    url = "mirror://sourceforge/ophcrack/${finalAttrs.version}/ophcrack-${finalAttrs.version}.tar.bz2";
    hash = "sha256-BIpt9XmDo6WjGsfE7BLfFqpJ5lKilnbZPU75WdUK7uA=";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/ophcrack/-/raw/c60118b40802e1162dcebfe5f881cf973b2334d3/debian/patches/fix_spelling_error.diff";
      hash = "sha256-Fc044hTU4Mtdym+HukGAwGzaLm7aVzV9KpvHvFUG2Sc=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/ophcrack/-/raw/e19d993a7dbf131d13128366e2aac270a685befc/debian/patches/qmake_crossbuild.diff";
      hash = "sha256-sOKXOBpAYGLacU6IxjRzy3HCnGm4DFowDL2qP+DzG8M=";
    })
  ];

  nativeBuildInputs = [ pkg-config ] ++ lib.optional enableGui libsForQt5.wrapQtAppsHook;
  buildInputs = [
    openssl
    expat
  ]
  ++ lib.optional enableGui libsForQt5.qtcharts;

  configureFlags = [
    "--with-libssl"
  ]
  ++ (
    if enableGui then
      [
        "--enable-gui"
        "--with-qt5charts"
      ]
    else
      [ "--disable-gui" ]
  );

  installPhase = lib.optional (stdenv.hostPlatform.isDarwin && enableGui) ''
    mkdir -p $out/Applications
    cp -R src/ophcrack.app $out/Applications/ophcrack.app
  '';

  meta = {
    description = "Free Windows password cracker based on rainbow tables";
    homepage = "https://ophcrack.sourceforge.io";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "ophcrack";
    platforms = lib.platforms.all;
  };
})
