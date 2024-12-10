{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  gtk3,
  fribidi,
  libpng,
  popt,
  libgsf,
  enchant,
  wv,
  librsvg,
  bzip2,
  libjpeg,
  perl,
  boost,
  libxslt,
  goffice,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "abiword";
  version = "3.0.5";

  src = fetchurl {
    url = "https://www.abisource.com/downloads/abiword/${version}/source/${pname}-${version}.tar.gz";
    hash = "sha256-ElckfplwUI1tFFbT4zDNGQnEtCsl4PChvDJSbW86IbQ=";
  };

  patches = [
    # Fix build with libxml2 2.12
    (fetchpatch {
      url = "https://gitlab.gnome.org/World/AbiWord/-/commit/2a06be6a10a0718f8a3d8e00c317f5042c99a467.patch";
      hash = "sha256-vfh81tGXe9dgnjcAtoWHOK8CtW7MZ75FFjnfKTkiKkk=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    perl
  ];

  buildInputs = [
    gtk3
    librsvg
    bzip2
    fribidi
    libpng
    popt
    libgsf
    enchant
    wv
    libjpeg
    boost
    libxslt
    goffice
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Word processing program, similar to Microsoft Word";
    mainProgram = "abiword";
    homepage = "https://www.abisource.com/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      pSub
      ylwghst
      sna
    ];
  };
}
