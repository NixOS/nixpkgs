{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  enableWX ? false,
  wxGTK32,
  enableXWin ? false,
  xorg,
  enablePNG ? false,
  cairo,
  pango,
}:

stdenv.mkDerivation rec {
  pname = "plplot";
  version = "5.15.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${pname}/${version}%20Source/${pname}-${version}.tar.gz";
    sha256 = "0ywccb6bs1389zjfmc9zwdvdsvlpm7vg957whh6b5a96yvcf8bdr";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    lib.optional enableWX wxGTK32
    ++ lib.optional enableXWin xorg.libX11
    ++ lib.optionals enablePNG [
      cairo
      pango
    ];

  passthru = {
    inherit (xorg) libX11;
    inherit
      enableWX
      enableXWin
      ;
  };

  cmakeFlags = [
    "-DBUILD_TEST=ON"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Cross-platform scientific graphics plotting library";
    mainProgram = "pltek";
    homepage = "https://plplot.org";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.lgpl2;
  };
}
