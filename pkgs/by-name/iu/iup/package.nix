{
  lib,
  stdenv,
  fetchurl,

  lsb-release,
  which,
  pkg-config,
  gtk3,
  canvasdraw,
  libGLU,
  ftgl,
  imtoolkit,
}:

stdenv.mkDerivation rec {
  pname = "iup";
  version = "3.31";

  src = fetchurl {
    url = "mirror://sourceforge/iup/${version}/Docs%20and%20Sources/${pname}-${version}_Sources.tar.gz";
    hash = "sha256-rYL2KweC5G/31KsWdl3yHLF+Z6xrjnLFDMhVH/VKFHQ=";
  };

  nativeBuildInputs = [
    lsb-release
    which
    pkg-config
  ];

  buildInputs = [
    gtk3
    canvasdraw
    libGLU
    ftgl
    imtoolkit
  ];

  makeFlags = [
    "USE_PKGCONFIG=Yes"
    "USE_GTK3=Yes"
    "USE_STATIC="
    "LINK_CAIRO=Yes"

    "iup"
    "iupgtk"
    "iupcd"
    "iupcontrols"
    "iupgl"
    "iup_plot"
    "iup_mglplot"
    "iupglcontrols"
    "iupim"
    "iupole"
    "iup_scintilla"
    "iupim"
    "iuptuio"
    "iupimglib"
    "ledc"
    "iupview"
  ];

  installPhase = ''
    install -m755 -d "$out/lib"
    install -m644 lib/*/lib*.so "$out/lib"
    install -m755 -d "$out/include"
    install -m644 include/* "$out/include"
  '';

  meta = {
    description = "C cross platform GUI toolkit";
    homepage = "https://www.tecgraf.puc-rio.br/iup/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ saturn745 ];
    platforms = lib.platforms.linux;
  };
}
