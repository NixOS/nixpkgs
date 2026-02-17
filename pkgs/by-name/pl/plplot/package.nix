{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  enableWX ? false,
  wxGTK32,
  enableXWin ? false,
  libx11,
  enablePNG ? false,
  cairo,
  pango,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plplot";
  version = "5.15.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/plplot/plplot/${finalAttrs.version}%20Source/plplot-${finalAttrs.version}.tar.gz";
    sha256 = "0ywccb6bs1389zjfmc9zwdvdsvlpm7vg957whh6b5a96yvcf8bdr";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    lib.optional enableWX wxGTK32
    ++ lib.optional enableXWin libx11
    ++ lib.optionals enablePNG [
      cairo
      pango
    ];

  passthru = {
    inherit
      enableWX
      enableXWin
      libx11
      ;
    # backwards compat
    libX11 = libx11;
  };

  cmakeFlags = [
    "-DBUILD_TEST=ON"
  ];

  doCheck = true;

  meta = {
    description = "Cross-platform scientific graphics plotting library";
    mainProgram = "pltek";
    homepage = "https://plplot.org";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl2;
  };
})
